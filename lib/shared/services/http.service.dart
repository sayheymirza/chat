import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:io';
import 'dart:math' as Math;

import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class HttpService extends GetxService {
  final Dio.Dio client = Dio.Dio();
  int index = 0;

  Future<dynamic> request({
    required String path,
    String? endpoint,
    String method = "GET",
    Map<String, dynamic>? data,
    bool auth = false,
    Dio.CancelToken? cancelToken,
  }) async {
    if (endpoint == null || endpoint.isEmpty) {
      // get endpoint from storage
      endpoint = Services.configs.get(key: CONSTANTS.STORAGE_ENDPOINT_API);
    }

    if (endpoint == null || endpoint.isEmpty) {
      // use default
      endpoint = CONSTANTS.DEFAULT_ENDPOINT_API;
    }

    var url = "$endpoint$path";

    var package = await Services.access.generatePackageInfo();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-app-time': DateTime.now().toIso8601String(),
      'x-app-flavor': CONSTANTS.FLAVOR,
      'x-app-version': package.version,
    };

    if (auth) {
      var accessToken =
          Services.configs.get(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    var i = ++index;

    var start = DateTime.now();

    log('[http.service.dart#$i] $method $url');

    var response = await client.request(
      url,
      data: data,
      cancelToken: cancelToken,
      options: Dio.Options(
        method: method,
        headers: headers,
      ),
    );

    var end = DateTime.now();

    log('[http.service.dart#$i] $method $path (${end.difference(start).inMilliseconds}ms)');

    return response.data;
  }

  Future<File?> download({
    required String url,
    required String directory,
    Function({
      required int percent,
      required int total,
      required int recive,
    })? onPercent,
    Function(dynamic info)? onInfo,
    Dio.CancelToken? cancelToken,
  }) async {
    try {
      var path = "$directory/${basename(url)}";

      if (onInfo != null) {
        onInfo({
          "filename": basename(url),
          'path': path,
        });
      }

      await client.download(
        url,
        path,
        cancelToken: cancelToken,
        onReceiveProgress: (int sent, int total) {
          if (onPercent != null) {
            var progress = ((100 * sent) / total).ceil();
            onPercent(percent: progress, recive: sent, total: total);
          }
        },
      );

      if (onPercent != null) {
        onPercent(percent: 100, recive: 0, total: 0);
      }

      return File(path);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> upload({
    required String path,
    required File file,
    required Function({
      required int percent,
      required int total,
      required int sent,
    }) callback,
    String? endpoint,
    Dio.CancelToken? cancelToken,
  }) async {
    if (endpoint == null || endpoint.isEmpty) {
      // get endpoint from storage
      endpoint = Services.configs.get(key: CONSTANTS.STORAGE_ENDPOINT_API);
    }

    if (endpoint == null || endpoint.isEmpty) {
      // use default
      endpoint = CONSTANTS.DEFAULT_ENDPOINT_API;
    }

    var url = "$endpoint$path";

    Map<String, String> headers = {};

    var accessToken = Services.configs.get(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    var bytes = await getBytesFromFileOrXFile(file);

    // mime
    var fileMime = lookupMimeType(file.path);

    // Use Dio to upload the file in streaming mode
    // Dio.FormData data = Dio.FormData.fromMap({
    //   "file": Dio.MultipartFile(
    //     fileStream, fileSize,
    //     filename: basename(file.path),
    //     // mime type
    //     contentType: MediaType.parse(fileMime ?? 'application/octet-stream'),
    //   ),
    // });

    Dio.FormData data = Dio.FormData.fromMap({
      "file": Dio.MultipartFile.fromBytes(
        bytes.toList(),
        filename: basename(file.path),
        contentType: MediaType.parse(fileMime ?? 'application/octet-stream'),
      ),
    });

    var i = ++index;

    var start = DateTime.now();

    log('[http.service.dart#$i] POST $path');

    print('googing to upload ...');

    var response = await client.post(
      url,
      data: data,
      options: Dio.Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
      onSendProgress: (int sent, int total) {
        var progress = Math.min(((100 * sent) / total).ceil(), 100);

        callback(
          percent: progress,
          sent: sent,
          total: total,
        );
      },
    );

    var end = DateTime.now();

    log('[http.service.dart#$i] POST $path (${end.difference(start).inMilliseconds}ms)');

    return response.data;
  }
}

Future<Uint8List> getBytesFromFileOrXFile(dynamic file) async {
  if (kIsWeb) {
    final response = await html.HttpRequest.request(
      file.path,
      responseType: 'arraybuffer',
    );
    // Convert NativeByteBuffer → Uint8List
    final byteBuffer = response.response;
    return byteBuffer.asUint8List();
  } else {
    // برای موبایل/دسکتاپ (غیر وب)
    if (file is File) {
      return await file.readAsBytes();
    } else {
      throw UnsupportedError('Unsupported file type on mobile');
    }
  }
}
