import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_send_sms/dialog_send_sms.view.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool showOptions = false.obs;
  RxBool openingChat = false.obs;
  RxBool loading = true.obs;

  Rx<ProfileModel> profile = ProfileModel().obs;

  @override
  void onInit() {
    super.onInit();

    load();
  }

  Future<void> load() async {
    var id = Get.parameters['id']!;
    var args = Get.arguments;

    showOptions.value = args != null && args['options'] != false;

    if (id == 'me') {
      var result = await ApiService.user.me();

      if (result != null) {
        profile.value = result;
        loading.value = false;
      } else {
        showSnackbar(message: 'خطا در دریافت پروفایل رخ داد');
      }
    } else {
      loadUser();
      fetch();
      Services.user.see(userId: id);
    }
  }

  Future<void> loadUser() async {
    try {
      var id = Get.parameters['id']!;
      var result = await Services.user.one(userId: id);

      if (result != null) {
        profile.value = result;
        loading.value = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetch() async {
    var id = Get.parameters['id']!;

    await Services.user.fetch(userId: id);

    loadUser();
  }

  void block({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.BLOCK,
    );

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.BLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر به بلاکی ها اضافه شد');
        fetch();
      }
    });
  }

  void unblock({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.UNBLOCK,
    );

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.UNBLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر از بلاکی ها حذف شد');
        fetch();
      }
    });
  }

  void favorite({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.FAVORITE,
    );

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.FAVORITE,
      );
      if (result) {
        showSnackbar(message: 'کاربر به علاقه مندی ها اضافه شد');
      }
    });
  }

  void disfavorite({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.DISFAVORITE,
    );

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.DISFAVORITE,
      );
      if (result) {
        showSnackbar(message: 'کاربر از علاقه مندی ها حذف شد');
      }
    });
  }

  void sendSMS({required String id}) {
    Get.bottomSheet(
      DialogSendSMSView(userId: id),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void startChat({required String id}) async {
    try {
      openingChat.value = true;
      update();
      var chatId = await Services.chat.createByUserId(userId: id);
      openingChat.value = false;
      update();

      if (chatId != null) {
        var path = '/app/chat/$chatId';

        if (Get.previousRoute == path) {
          Get.back();
        } else {
          Get.toNamed(path);
        }
      }
    } catch (e) {
      //
    }
  }

  void sendDefaultMessage({required String id}) async {
    Get.toNamed(
      '/app/default-message',
      arguments: {
        'id': id,
      },
    );
  }

  void report({
    required String id,
    required String fullname,
  }) async {
    Get.toNamed(
      '/app/report',
      arguments: {
        'id': id,
        'fullname': fullname,
      },
    );
  }
}
