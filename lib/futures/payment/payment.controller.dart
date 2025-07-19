import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  RxString status = "loading".obs;

  @override
  void onInit() {
    super.onInit();

    Services.chrome.transparent(
      statusBarIconBrightness: Brightness.dark,
    );

    var result = Get.parameters['status'].toString().toLowerCase();

    var map = {'true': 'ok', 'false': 'nok', 'ok': 'ok', 'nok': 'nok'};

    status.value = map[result] ?? 'nok';

    if (status.value == 'ok') {
      Services.profile.fetchMyProfile();
    }
  }

  @override
  void onClose() {
    super.onClose();

    Services.chrome.transparent();
  }

  void home() {
    NavigationToNamed('/');
    Get.offAllNamed('/');
  }
}
