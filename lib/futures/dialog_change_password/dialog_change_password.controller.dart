import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class DialogChangePasswordController extends GetxController {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  RxBool disabled = false.obs;
  RxBool visablePassword = false.obs;

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    if (subevents == null) {
      NavigationOpenedDialog();

      subevents = event.on<EventModel>().listen((data) async {
        if (data.event == EVENTS.NAVIGATION_BACK) {
          Get.back();
        }
      });
    }
  }

  void submit() async {
    if (formKey.currentState!.saveAndValidate()) {
      var value = formKey.currentState!.value;

      if (value['password'] != value['password_repeat']) {
        showSnackbar(message: 'رمز عبور با تکرار آن یکی نمی باشد');
        return;
      }

      disabled.value = true;

      var result = await ApiService.user.changePassword(
        password: value['password'],
      );

      if (result.success) {
        Get.back();
      }

      disabled.value = false;
      showSnackbar(message: result.message);
    }
  }
}
