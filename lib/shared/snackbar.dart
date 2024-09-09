import 'package:chat/shared/vibration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar({required String message}) {
  vibrate();

  Get.snackbar(
    '',
    '',
    titleText: Container(),
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    overlayBlur: 0,
    barBlur: 0,
    borderRadius: 10,
    backgroundColor: Colors.grey.shade800,
  );
}
