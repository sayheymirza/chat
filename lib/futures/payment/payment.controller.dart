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

    status.value = Get.parameters['status'].toString().toLowerCase();

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
    Get.offAllNamed('/');
  }
}
