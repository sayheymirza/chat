import 'dart:developer';

import 'package:chat/shared/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;

class PageViewController extends GetxController {
  RxString data = ''.obs;
  RxString link = ''.obs;
  RxBool loading = true.obs;
  RxBool errored = false.obs;

  void load({
    required String page,
  }) async {
    var value = Services.configs.get(key: 'page:$page');

    link.value = value;
    loading.value = true;
    errored.value = false;

    if (kIsWeb) {
      // with http download text
      try {
        var response = await Dio.Dio().get(value);

        if (response.statusCode == 200) {
          data.value = response.data;
        } else {
          errored.value = true;
        }
      } catch (e) {
        errored.value = true;
      }
    } else {
      var file = await Services.cache.load(
        url: value,
        category: 'page',
      );

      if (file != null) {
        data.value = file.readAsStringSync();
      } else {
        errored.value = true;
      }
    }

    loading.value = false;

    log('[page.controller.dart] $page loaded');
  }
}
