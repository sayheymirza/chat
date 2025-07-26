import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AuthForgotController extends GetxController {
  GlobalKey<FormBuilderState> forgotFormKey = GlobalKey<FormBuilderState>();
  RxBool disabled = false.obs;

  Future<void> submit() async {
    if (forgotFormKey.currentState!.saveAndValidate() == false) return;

    try {
      disabled.value = true;

      var result = await ApiService.auth.forgot(
        username: forgotFormKey.currentState!.value['phone'],
      );

      showSnackbar(message: result.message);

      disabled.value = false;
      if (result.success) {
        Get.offAndToNamed(
          '/auth/login',
          result: {
            'phone': forgotFormKey.currentState!.value['phone'],
          },
        );
      }
    } catch (e) {
      disabled.value = false;
    }
  }
}
