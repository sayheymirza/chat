import 'dart:developer';

import 'package:chat/shared/services/chrome.service.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

class Services {
  static put() async {
    log('[services.dart] start put Get services');
    Get.put(ChromeService(), tag: 'chrome');
    Get.put(HttpService(), tag: 'http');
    log('[services.dart] end put Get services');
  }
}
