import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_send_sms/dialog_send_sms.view.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<Relation> relation = Relation.empty.obs;

  RxBool showOptions = false.obs;

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

    showOptions.value = args != null && args['options'] != false;

    if (id == 'me') {
      var result = await ApiService.user.me();

      if (result != null) {
        if (result.relation != null) {
          relation.value = result.relation!;
        }

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

              // set relation
              if (data.first.relation != null) {
                relation.value = data.first.relation!;
              }
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

  void block({required String id}) async {
    relation.value = relation.value.copyWith({"blocked": true});
    update();

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
    relation.value = relation.value.copyWith({"blocked": false});
    update();

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
    relation.value = relation.value.copyWith({"favorited": true});

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
    relation.value = relation.value.copyWith({"favorited": false});

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
