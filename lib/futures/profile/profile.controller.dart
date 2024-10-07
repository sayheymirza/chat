import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_send_sms/dialog_send_sms.view.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profile = ProfileModel().obs;
  Rx<Relation> relation = Relation.empty.obs;

  RxBool loading = true.obs;
  RxBool showOptions = false.obs;

  Future<void> load() async {
    var params = Get.arguments;

    var result = await (params == null || params['id'] == 0
        ? ApiService.user.me()
        : ApiService.user.one(
            id: params['id'],
          ));

    if (result != null) {
      if (result.relation != null) {
        relation.value = result.relation!;
      }
      profile.value = result;
      loading.value = false;
      showOptions.value = params != null && params['options'] != false;
    } else {
      Get.back();
      showSnackbar(message: 'خطا در دریافت پروفایل رخ داد');
    }
  }

  void block() async {
    relation.value = relation.value.copyWith({"blocked": true});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: profile.value.id!,
        action: RELATION_ACTION.BLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر به بلاکی ها اضافه شد');
      }
    });
  }

  void unblock() async {
    relation.value = relation.value.copyWith({"blocked": false});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: profile.value.id!,
        action: RELATION_ACTION.UNBLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر از بلاکی ها حذف شد');
      }
    });
  }

  void favorite() async {
    relation.value = relation.value.copyWith({"favorited": true});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: profile.value.id!,
        action: RELATION_ACTION.FAVORITE,
      );
      if (result) {
        showSnackbar(message: 'کاربر به علاقه مندی ها اضافه شد');
      }
    });
  }

  void disfavorite() async {
    relation.value = relation.value.copyWith({"favorited": false});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: profile.value.id!,
        action: RELATION_ACTION.DISFAVORITE,
      );
      if (result) {
        showSnackbar(message: 'کاربر از علاقه مندی ها حذف شد');
      }
    });
  }

  void sendSMS() {
    Get.bottomSheet(
      const DialogSendSMSView(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}
