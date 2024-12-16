import 'dart:developer';

import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

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

    var file = await Services.cache.load(
      url: value,
      category: 'page',
    );

    if (file != null) {
      data.value = file.readAsStringSync();
    } else {
      errored.value = true;
    }

    loading.value = false;

    log('[page.controller.dart] $page loaded');
  }
}
