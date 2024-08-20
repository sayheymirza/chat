import 'dart:developer';

import 'package:chat/shared/env.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class HttpService extends GetxService {
  final Dio _client = Dio();
  int index = 0;

  Future<dynamic> request({
    required String path,
    String? endpoint,
    String method = "GET",
    Map<String, dynamic>? data,
    bool auth = false,
    CancelToken? cancelToken,
  }) async {
    if (endpoint == null || endpoint.isEmpty) {
      // get endpoint from storage
      endpoint = GetStorage().read<String>(ENV.STORAGE_ENDPOINT_API);
    }

    if (endpoint == null || endpoint.isEmpty) {
      // use default
      endpoint = ENV.DEFAULT_ENDPOINT_API;
    }

    var url = "$endpoint$path";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (auth) {
      var accessToken = GetStorage().read<String>(ENV.STORAGE_ACCESS_TOKEN);

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
      options: Options(
        method: method,
        headers: headers,
      ),
    );

    var end = DateTime.now();

    log('[http.service.dart#$i] $method $path (${end.difference(start).inMilliseconds}ms)');

    return response.data;
  }
}
