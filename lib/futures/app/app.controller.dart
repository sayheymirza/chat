import 'dart:developer';

import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxInt view = 0.obs;

  @override
  void onInit() {
    super.onInit();

    Services.profile.fetchMyProfile();
  }

  void setView(int value) {
    view.value = value;
    log('[app.controller.dart] view changed to $value');
  }
}
