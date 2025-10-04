import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_send_sms/dialog_send_sms.view.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool showOptions = false.obs;
  RxBool openingChat = false.obs;
  RxBool loading = true.obs;

  Rx<ProfileModel> profile = ProfileModel().obs;

  String? get id {
    return profile.value.id ?? Get.parameters['id'];
  }

  @override
  void onInit() {
    super.onInit();

    load();
  }

  Future<void> load() async {
    var args = Get.arguments;

    if (kIsWeb) {
      NavigationToNamed('/profile/$id');
    }

    showOptions.value = args != null && args['options'] != false;

    if (id == 'me') {
      var result = await ApiService.user.me();

      if (result != null) {
        profile.value = result;
        loading.value = false;
      } else {
        showSnackbar(message: 'خطا در دریافت پروفایل رخ داد');
      }
    } else if (id != null) {
      loadUser();
      fetch();
      Services.user.see(userId: id!);
    }
  }

  Future<void> loadUser() async {
    try {
      var result = await Services.user.one(userId: id!);

      if (result != null && result.status != 'unknown') {
        profile.value = result;
        loading.value = false;
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetch() async {
    await Services.user.fetch(userId: id!);

    loadUser();
  }

  void block({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.BLOCK,
    );

    showSnackbar(message: '${profile.value.fullname} به بلاکی ها اضافه شد');

    loadUser();

    Services.queue.add(() async {
      await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.BLOCK,
      );
    });
  }

  void unblock({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.UNBLOCK,
    );

    showSnackbar(message: '${profile.value.fullname} از بلاکی ها حذف شد');

    loadUser();

    Services.queue.add(() async {
      await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.UNBLOCK,
      );
    });
  }

  void favorite({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.FAVORITE,
    );

    showSnackbar(
      message: '${profile.value.fullname} به علاقه مندی ها اضافه شد',
    );

    loadUser();

    Services.queue.add(() async {
      await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.FAVORITE,
      );
    });
  }

  void disfavorite({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.DISFAVORITE,
    );

    showSnackbar(
      message: '${profile.value.fullname} از علاقه مندی ها حذف شد',
    );

    loadUser();

    Services.queue.add(() async {
      await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.DISFAVORITE,
      );
    });
  }

  void like({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.LIKE,
    );

    loadUser();

    Services.queue.add(() async {
      // await ApiService.user.react(
      //   user: id,
      //   action: RELATION_ACTION.LIKE,
      // );

      Services.user.like(userId: id);
    });
  }

  void dislike({required String id}) async {
    await Services.user.relation(
      userId: id,
      action: RELATION_ACTION.DISLIKE,
    );

    loadUser();

    Services.queue.add(() async {
      // await ApiService.user.react(
      //   user: id,
      //   action: RELATION_ACTION.DISLIKE,
      // );

      Services.user.dislike(userId: id);
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
    NavigationToNamed('/app/default-message', params: 'id=$id');
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
