import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountVerifyPhoneController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');

  RxBool disabled = false.obs;

  RxString time = ''.obs;
  RxBool sent = false.obs;

  RxString code = ''.obs;
  TextEditingController codeController = TextEditingController();

  int end = 0;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    var otp = Services.configs.get(key: 'OTP');

    if (otp != null) {
      var otp_end = otp['end'];

      var now = DateTime.now().millisecondsSinceEpoch;

      if (now < otp_end) {
        end = otp_end;
        sent.value = true;
        startTimer();

        codeController.text = '';
      } else {
        Services.configs.unset(key: 'OTP');
        requestOTP();
      }
    } else {
      requestOTP();
    }
  }

  @override
  void onClose() {
    super.onClose();

    if (timer != null) {
      timer!.cancel();
    }
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      var now = DateTime.now().millisecondsSinceEpoch;

      if (now > end) {
        timer!.cancel();
        time.value = '00:00';
      } else {
        var date_now = DateTime.fromMillisecondsSinceEpoch(now);
        var date_end = DateTime.fromMillisecondsSinceEpoch(end);

        var date_diff = date_end.difference(date_now);

        var minute = date_diff.inMinutes
            .remainder(60); // دقیقه‌های باقیمانده را محاسبه می‌کنیم
        var second = date_diff.inSeconds
            .remainder(60); // ثانیه‌های باقیمانده را محاسبه می‌کنیم

        time.value =
            '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';

        log('[account_verify_phone.controller.dart] ${time.value} remaning');
      }
    });
  }

  void requestOTP() async {
    disabled.value = true;

    var result = await ApiService.user.requestOTP();

    showSnackbar(message: result.message);

    disabled.value = false;

    if (result.end != 0) {
      disabled.value = false;
      sent.value = true;
      codeController.text = '';
      end = result.end;
      Services.configs.set(
        key: 'OTP',
        value: {
          'end': result.end,
        },
      );
      update();
      startTimer();
    }
  }

  Future<void> submit() async {
    if (disabled.value) return;

    if (time.value == '00:00') {
      showSnackbar(message: 'کد تایید منقضی شده است');
      if (timer != null) {
        timer!.cancel();
      }
      return;
    }

    // code phone
    if (code.value.isEmpty) {
      return showSnackbar(message: 'کد تایید را وارد کنید');
    }
    if (code.value.length != 4) {
      return showSnackbar(message: 'کد تایید باید ۴ رقمی باشد');
    }

    disabled.value = true;

    var result = await ApiService.user.verifyOTP(
      code: CustomValidator.convertPN2EN(code.value),
    );

    if (result.success) {
      if (timer != null) {
        timer!.cancel();
      }

      Services.configs.unset(key: 'OTP');

      Services.profile.profile.value = Services.profile.profile.value.copyWith(
        {'verified': true},
      );

      Get.back(canPop: true);
    }

    disabled.value = false;

    showSnackbar(message: result.message);
  }
}
