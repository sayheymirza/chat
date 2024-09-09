import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class DialogChangePhoneController extends GetxController {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  RxBool disabled = false.obs;

  void submit() async {
    if (formKey.currentState!.saveAndValidate()) {
      disabled.value = true;

      var result = await ApiService.user.changePhone(
        phone: formKey.currentState!.value['phone'],
      );

      if (result.success) {
        // Services.profile.profile.value.phone =
        //     formKey.currentState!.value['phone'];

        Services.profile.profile.value =
            Services.profile.profile.value.copyWith(
          {'phone': formKey.currentState!.value['phone']},
        );

        Get.back();
      }

      disabled.value = false;
      showSnackbar(message: result.message);
    }
  }
}
