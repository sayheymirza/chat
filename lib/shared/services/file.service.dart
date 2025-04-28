import 'dart:developer';
import 'dart:io';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/download_upload.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

int uuid() {
  var now = DateTime.now();

  return now.year + now.month + now.day + now.hour + now.minute + now.second;
}

class FileService extends GetxService {
  RxMap<int, DUModel> uploads = <int, DUModel>{}.obs;
  RxMap<int, DUModel> downloads = <int, DUModel>{}.obs;

  Future<String?> hash({required File file}) async {
    final output = AccumulatorSink<Digest>();
    final input = sha256.startChunkedConversion(output);

    await for (final chunk in file.openRead()) {
      input.add(chunk);
    }
    input.close();

    return output.events.single.toString();
  }

  DUModel? getUploadByFile(File file) {
    if (uploads.isEmpty) return null;

    var model = uploads.values.where(
      (element) => element.file?.path == file.path,
    );

    if (model.isNotEmpty) {
      return model.first;
    }

    return null;
  }

  DUModel? getDownloadByURL(String url) {
    var model = downloads.values.where(
      (element) => element.url == url,
    );

    if (model.isNotEmpty) {
      return model.first;
    }

    return null;
  }

  Future<DUModel?> upload({
    required File file,
    String category = "file",
    dynamic meta = const {},
    bool cache = false,
    Function(DUModel result)? onDone,
    Function(DUModel result)? onProgress,
    Function(DUModel result)? onError,
  }) async {
    try {
      String filePath = file.path;

      if (!kIsWeb) {
        // فقط موبایل/دسکتاپ
        var directory = Directory(
          '${(await getApplicationCacheDirectory()).path}/files/$category',
        );

        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        filePath = '${directory.path}/${basename(file.path)}';

        // فایل رو کپی کن
        if (!File(filePath).existsSync()) {
          file.copySync(filePath);
        }
      }

      // فایل آماده است
      if (uploads.values.any((element) => element.file?.path == filePath)) {
        return getUploadByFile(file);
      }

      var id = uuid();
      var filename = basename(filePath);
      var cancelToken = CancelToken();

      log('[file.service.dart] upload started for id $id');

      int fileSize = 0;
      if (!kIsWeb) {
        fileSize = await file.length(); // بدون خطا
      }

      uploads[id] = DUModel(
        id: id,
        file: file,
        category: category,
        filename: filename,
        percent: 0,
        total: fileSize,
        sentOrRecived: 0,
        cancelToken: cancelToken,
        onDone: onDone,
        onProgress: onProgress,
        onError: onError,
        meta: meta,
        cache: cache,
      );

      Services.notification.progress(
        id: id,
        title: "آپلود $filename",
        progress: 0,
        channel: 'upload_channel',
      );

      cancelToken.whenCancel.whenComplete(() {
        log('[file.service.dart] upload canceled for id $id');
        uploads.remove(id);
        Services.notification.dismiss(id: id);

        var upload = uploads[id];
        if (upload?.onError != null) {
          upload!.onError!(upload);
        }
      });

      var result = await ApiService.data.upload(
        file: file,
        callback: ({
          int percent = 0,
          int total = 0,
          int sent = 0,
        }) {
          if (uploads[id] != null) {
            uploads[id]!.percent = percent;
            uploads[id]!.sentOrRecived = sent;

            Services.notification.progress(
              id: id,
              title: "آپلود $filename",
              progress: percent.toDouble(),
              channel: 'upload_channel',
            );

            if (uploads[id]?.onProgress != null) {
              onProgress!(uploads[id]!);
            }
          }
        },
        cancelToken: cancelToken,
      );

      await Services.notification.progress(
        id: id,
        title: "آپلود $filename",
        progress: 100.toDouble(),
        channel: 'upload_channel',
      );

      log('[file.service.dart] upload dismissing for id $id');
      Services.notification.dismiss(id: id);

      var output = DUModel(
        done: result.success,
        id: id,
        category: category,
        filename: filename,
        percent: 100,
        total: fileSize,
        sentOrRecived: fileSize,
        cancelToken: cancelToken,
        url: result.url,
        fileId: result.fileId,
        file: file,
        meta: meta,
      );

      if (uploads[id]?.onDone != null && result.success) {
        uploads[id]!.onDone!(output);
      }

      if (uploads[id]?.onProgress != null) {
        uploads[id]!.onProgress!(output);
      }

      if (uploads[id]?.onError != null && !result.success) {
        uploads[id]!.onError!(output);
      }

      // اگر موفق و cache خواسته شده
      if (result.success && uploads[id]?.cache == true && !kIsWeb) {
        var cacheFilePath = filePath;
        await database.into(database.cacheTable).insert(
              CacheTableCompanion.insert(
                url: output.url!,
                file: cacheFilePath,
                size: fileSize,
                category: output.category,
              ),
            );
      }

      uploads.remove(id);

      return output;
    } catch (e) {
      print('[upload.service.dart] error is: $e');

      var model = getUploadByFile(file);

      if (model?.onError != null) {
        model!.onError!(model);
      }

      if (model != null) {
        uploads.remove(model.id);
      }

      return null;
    }
  }

  Future<void> download({
    required String url,
    required String category,
    int total = 0,
    dynamic meta = const {},
    Function(DUModel result)? onDone,
    Function(DUModel result)? onProgress,
    Function(DUModel result)? onError,
  }) async {
    try {
      // check file is downloading or not
      if (downloads.values.any((element) => element.url == url)) {
        return;
      }

      var filename = basename(url);

      var directory = Directory(
        '${(await getApplicationCacheDirectory()).path}/downloads/$category',
      );

      if (!url.startsWith('http')) {
        // cp file
        var file = File(url);
        file.copySync('${directory.path}/$filename');
        return;
      }

      var id = uuid();
      var cancelToken = CancelToken();

      downloads[id] = DUModel(
        id: id,
        category: category,
        filename: filename,
        percent: 0,
        total: total,
        sentOrRecived: 0,
        cancelToken: cancelToken,
        url: url,
        meta: meta,
        onDone: onDone,
        onProgress: onProgress,
        onError: onError,
      );

      // make the notification
      Services.notification.progress(
        id: id,
        title: "دانلود $filename",
        progress: 0,
        channel: 'download_channel',
      );

      cancelToken.whenCancel.whenComplete(() {
        // delete it from queue
        downloads.remove(id);
        // dismiss notification
        Services.notification.dismiss(id: id);

        // onError
        if (downloads[id]?.onError != null) {
          downloads[id]!.onError!(downloads[id]!);
        }
      });

      var result = await Services.http.download(
        url: url,
        onPercent: ({
          required int percent,
          required int recive,
          required int total,
        }) {
          downloads[id]!.sentOrRecived = recive;

          downloads[id]!.percent =
              ((100 * recive) / downloads[id]!.total).ceil();

          Services.notification.progress(
            id: id,
            title: "دانلود $filename",
            progress: percent.toDouble(),
            channel: 'download_channel',
          );

          if (downloads[id]?.onProgress != null) {
            downloads[id]!.onProgress!(downloads[id]!);
          }
        },
        cancelToken: cancelToken,
        directory: directory.path,
      );

      await Services.notification.progress(
        id: id,
        title: "دانلود $filename",
        progress: 100.toDouble(),
        channel: 'download_channel',
      );

      Services.notification.dismiss(id: id);

      downloads[id]!.percent = 100;

      if (result != null) {
        downloads[id]!.file = result;
        downloads[id]!.total = result.statSync().size;
        downloads[id]!.sentOrRecived = result.statSync().size;

        // onDone
        if (downloads[id]!.onDone != null) {
          downloads[id]!.onDone!(downloads[id]!);
        }
      }
    } catch (e) {
      print(e);

      // onError
      var model = getDownloadByURL(url);

      if (model?.onError != null) {
        model!.onError!(model);
      }
    }
  }
}
