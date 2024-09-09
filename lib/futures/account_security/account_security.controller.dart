import 'dart:async';

import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/vibration.dart';
import 'package:get/get.dart';

class AccountSecurityController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');
  Timer? timer;

  void submit() {
    if (timer != null) {
      timer!.cancel();
    }

    profile.profile.value = profile.profile.value.copyWith({});

    timer = Timer(const Duration(seconds: 1), () {
      Services.profile.changeSettings().then((_) {
        vibrate();
      });
    });
  }
}
