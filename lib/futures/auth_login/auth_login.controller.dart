import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/env.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthLoginController extends GetxController {
  GlobalKey<FormBuilderState> loginFormKey = GlobalKey<FormBuilderState>();
  RxBool disabled = false.obs;
  RxBool visablePassword = false.obs;

  Future<void> submit() async {
    if (loginFormKey.currentState!.saveAndValidate() == false) return;

    try {
      disabled.value = true;

      var result = await ApiService.auth.login(
        username: loginFormKey.currentState!.value['phone'],
        password: loginFormKey.currentState!.value['password'],
      );

      showSnackbar(message: result.message);

      if (result.token != null) {
        // store token
        GetStorage().write(ENV.STORAGE_ACCESS_TOKEN, result.token);

        Get.offAllNamed('/app');
      }

      disabled.value = false;
    } catch (e) {
      print(e);

      disabled.value = false;
    }
  }
}
