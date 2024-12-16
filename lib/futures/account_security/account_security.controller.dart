import 'dart:async';

import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/vibration.dart';
import 'package:get/get.dart';

class AccountSecurityController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');
  Timer? timer;
  RxBool permissionToNotification = false.obs;
  RxBool permissionToGPS = false.obs;
  RxBool permissionToMicrophone = false.obs;

  @override
  void onInit() {
    super.onInit();

    init();
  }

  void init() async {
    var mic = await Services.permission.has("mic");
    var gps = await Services.permission.has("gps");
    var notification = await Services.permission.has("notification");

    permissionToMicrophone.value = mic;
    permissionToGPS.value = gps;
    permissionToNotification.value = notification;
  }

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
