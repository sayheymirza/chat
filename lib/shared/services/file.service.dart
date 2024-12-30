import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/download_upload.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

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
      // copy file to cache storage
      var directory = Directory(
        '${(await getApplicationCacheDirectory()).path}/files/$category',
      );

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      var filePath = '${directory.path}/${basename(file.path)}';

      // check file is uploading or not
      if (uploads.values.any((element) => element.file?.path == filePath)) {
        // return the current upload
        return getUploadByFile(file);
      }

      // copy file to cache storage
      file.copySync(filePath);

      file = File(filePath);

      var id = uuid();
      var filename = basename(file.path);
      var cancelToken = CancelToken();

      log('[file.service.dart] upload started for id $id');

      uploads[id] = DUModel(
        id: id,
        file: file,
        category: category,
        filename: filename,
        percent: 0,
        total: file.statSync().size,
        sentOrRecived: 0,
        cancelToken: cancelToken,
        onDone: onDone,
        onProgress: onProgress,
        onError: onError,
        meta: meta,
        cache: cache,
      );

      // make the notification
      Services.notification.progress(
        id: id,
        title: "آپلود $filename",
        progress: 0,
        channel: 'upload_channel',
      );

      cancelToken.whenCancel.whenComplete(() {
        log('[file.service.dart] upload canceled for id $id');
        // delete it from queue
        uploads.remove(id);
        // dismiss notification
        Services.notification.dismiss(id: id);

        // onError
        if (uploads[id]?.onError != null) {
          log('[file.service.dart] upload onError for id $id');
          uploads[id]!.onError!(uploads[id]!);
        }

        // remove from uploads
        uploads.remove(id);
      });

      var result = await ApiService.data.upload(
        file: file,
        callback: ({
          int percent = 0,
          int total = 0,
          int sent = 0,
        }) {
          uploads[id]!.percent = percent;
          uploads[id]!.sentOrRecived = sent;

          Services.notification.progress(
            id: id,
            title: "آپلود $filename",
            progress: percent.toDouble(),
            channel: 'upload_channel',
          );

          if (uploads[id]?.onProgress != null) {
            log('[file.service.dart] upload onProgress for id $id');
            onProgress!(uploads[id]!);
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
        total: file.statSync().size,
        sentOrRecived: file.statSync().size,
        cancelToken: cancelToken,
        url: result.url,
        fileId: result.fileId,
        file: file,
        meta: meta,
      );

      // onDone
      if (uploads[id]!.onDone != null && result.success) {
        log('[file.service.dart] upload onDone for id $id');
        uploads[id]!.onDone!(output);
      }

      // onProgress
      if (uploads[id]!.onProgress != null) {
        log('[file.service.dart] upload onProgress for id $id');
        uploads[id]!.onProgress!(output);
      }

      // onError if result success is false
      if (uploads[id]!.onError != null && !result.success) {
        log('[file.service.dart] upload onProgress for id $id');
        uploads[id]!.onError!(output);
      }

      if (result.success &&
          uploads[id]?.cache == true &&
          uploads[id]!.file!.existsSync()) {
        await database.into(database.cacheTable).insert(
              CacheTableCompanion.insert(
                url: output.url!,
                file: output.file!.path,
                size: output.file!.statSync().size,
                category: output.category,
              ),
            );
      }

      uploads[id] = output;

      // remove
      if (result.success == false) {
        uploads.remove(id);
      }

      // if success (put to cache)

      return output;
    } catch (e) {
      print(e);

      // onError
      var model = getUploadByFile(file);

      if (model?.onError != null) {
        log('[file.service.dart] upload onError for id ${model!.id}');
        model.onError!(model);
      }

      // remove
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
