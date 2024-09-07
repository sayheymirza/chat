import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;

import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:get/get.dart';
import 'package:path/path.dart';

class HttpService extends GetxService {
  final Dio.Dio _client = Dio.Dio();
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

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (auth) {
      var accessToken =
          Services.configs.get(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      } else {
        return Future.error("Unauthorized");
      }
    }

    var i = ++index;

    var start = DateTime.now();

    log('[http.service.dart#$i] $method $path');

    var response = await _client.request(
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

  Future<dynamic> upload({
    required String path,
    required File file,
    required Function(int precent) callback,
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

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var accessToken = Services.configs.get(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    } else {
      return Future.error("Unauthorized");
    }

    Dio.FormData data = Dio.FormData.fromMap({
      "file": await Dio.MultipartFile.fromFile(
        file.path,
        filename: basename(file.path),
      ),
    });

    var i = ++index;

    var start = DateTime.now();

    log('[http.service.dart#$i] POST $path');

    var response = await _client.post(
      url,
      data: data,
      options: Dio.Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
      onSendProgress: (int sent, int total) {
        var progress = Math.min(((100 * sent) / total).ceil(), 100);

        callback(progress);
      },
    );

    var end = DateTime.now();

    log('[http.service.dart#$i] POST $path (${end.difference(start).inMilliseconds}ms)');

    return response.data;
  }
}
