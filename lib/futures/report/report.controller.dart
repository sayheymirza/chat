import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  RxBool disabled = false.obs;

  @override
  void onInit() {
    super.onInit();

    var params = Get.arguments;
    var id = params['id'];
    var fullname = params['fullname'];

    var title = 'تخطی $fullname با کد کاربری $id';

    Timer(const Duration(milliseconds: 300), () {
      formKey.currentState!.patchValue({
        'reciver': '0',
        'title': title,
      });
    });
  }

  void submit() async {
    if (disabled.value) return;

    if (formKey.currentState!.saveAndValidate()) {
      try {
        disabled.value = true;

        var value = formKey.currentState!.value;

        var result = await ApiService.data.contact(
          reciver: '0',
          title: value['title'],
          description: value['description'],
          file: value['image'],
          user: int.parse(Get.arguments['id'].toString()),
        );

        disabled.value = false;

        if (result.status) {
          Get.back();
        }

        showSnackbar(message: result.message);
      } catch (e) {
        disabled.value = false;
        //
      }
    }
  }
}
