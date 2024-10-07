import 'dart:developer';

import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class PageViewController extends GetxController {
  RxString data = ''.obs;
  RxString link = ''.obs;

  void load({
    required String page,
  }) async {
    var value = Services.configs.get(key: 'page:$page');

    link.value = value;

    var file = await Services.cache.load(
      url: value,
      category: 'page',
    );

    if (file != null) {
      data.value = file.readAsStringSync();
    }

    log('[page.controller.dart] $page loaded');
  }
}
