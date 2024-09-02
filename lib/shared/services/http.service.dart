import 'dart:developer';

import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

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
