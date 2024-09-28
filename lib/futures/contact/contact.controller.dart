import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  RxBool disabled = false.obs;

  void submit() async {
    if (disabled.value) return;

    if (formKey.currentState!.saveAndValidate()) {
      try {
        disabled.value = true;

        var value = formKey.currentState!.value;

        var result = await ApiService.data.contact(
          reciver: value['reciver'],
          title: value['title'],
          description: value['description'],
          file: value['image'],
        );

        disabled.value = false;

        if (result.status) {
          formKey.currentState!.reset();
        }

        showSnackbar(message: result.message);
      } catch (e) {
        disabled.value = false;
      }
    }
  }
}
