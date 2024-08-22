import 'dart:developer';

import 'package:chat/shared/services/chrome.service.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:get/get.dart';

class Services {
  static ChromeService get chrome => Get.find(tag: 'chrome');
  static ProfileService get profile => Get.find(tag: 'profile');

  static put() async {
    log('[services.dart] start put Get services');
    Get.put(ChromeService(), tag: 'chrome');
    Get.put(HttpService(), tag: 'http');
    Get.put(ProfileService(), tag: 'profile');
    log('[services.dart] end put Get services');
  }
}
