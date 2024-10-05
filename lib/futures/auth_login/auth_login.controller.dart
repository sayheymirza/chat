import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AuthLoginController extends GetxController {
  GlobalKey<FormBuilderState> loginFormKey = GlobalKey<FormBuilderState>();
  RxBool disabled = false.obs;
  RxBool visablePassword = false.obs;

  Future<void> submit() async {
    if (loginFormKey.currentState!.saveAndValidate() == false) return;

    try {
      disabled.value = true;

      var result = await ApiService.auth.login(
        username: CustomValidator.convertPN2EN(
            loginFormKey.currentState!.value['phone']),
        password: CustomValidator.convertPN2EN(
            loginFormKey.currentState!.value['password']),
      );

      showSnackbar(message: result.message);

      if (result.token != null) {
        // store token
        Services.configs.set(
          key: CONSTANTS.STORAGE_ACCESS_TOKEN,
          value: result.token,
        );

        Get.offAllNamed('/app');
      }

      disabled.value = false;
    } catch (e) {
      disabled.value = false;
    }
  }
}
