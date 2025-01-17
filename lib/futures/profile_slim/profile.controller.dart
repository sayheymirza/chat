import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_send_sms/dialog_send_sms.view.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSlimController extends GetxController {
  RxBool openingChat = false.obs;

  StreamController<List<ProfileModel>> profile =
      StreamController<List<ProfileModel>>();
  bool streamed = false;

  @override
  void onInit() {
    super.onInit();

    load();
  }

  @override
  void onClose() {
    super.onClose();

    profile.close();
  }

  Future<void> load() async {
    var id = Get.parameters['id']!;
    var args = Get.arguments;


    if (id == 'me') {
      var result = await ApiService.user.me();

      if (result != null) {
        profile.add([result]);
      } else {
        showSnackbar(message: 'خطا در دریافت پروفایل رخ داد');
      }
    } else {
      if (streamed == false) {
        try {
          var result = await Services.user.stream(userId: id);

          var sub = result.listen((data) {
            if (!profile.isClosed && data.isNotEmpty) {
              profile.add(data);
            }
          });

          profile.onCancel = () => sub.cancel();
        } catch (e) {
          print(e);
        }

        streamed = true;

        fetch();
      }
    }
  }

  Future<void> fetch() async {
    var id = Get.parameters['id']!;

    await Services.user.fetch(userId: id);
  }
}
