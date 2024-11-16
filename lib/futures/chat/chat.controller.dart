import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_delete_chat/dialog_delete_chat.view.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/widgets/chat/chat_card/chat_card_verify.widget.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<Relation> relation = Relation.empty.obs;

  List<Widget> children = [];

  Map<String, ChatMessageModel> message = {};
  List<ChatMessageModel> get messages => message.values.toList()
    ..sort((a, b) => b.sentAt.microsecondsSinceEpoch
        .compareTo(a.sentAt.microsecondsSinceEpoch));

  StreamController<ProfileModel> profileStream =
      StreamController<ProfileModel>();

  int page = 0;
  int limit = 20;
  bool ended = false;
  bool loading = false;

  @override
  void onInit() {
    super.onInit();

    load();
  }

  Future<void> load() async {
    try {
      var id = Get.parameters['id'];

      // get user id
      var userId = await Services.chat.getUserIdFromChatId(id: id!);

      if (userId == null) {
        Get.back();
      }

      Services.chat.selectedChat.value = id;

      var result = await Services.user.stream(userId: userId!);

      var sub = result.listen((data) {
        profileStream.add(data.last);
      });

      profileStream.onCancel = () => sub.cancel();

      messaging();

      childing();
    } catch (e) {
      print(e);
    }
  }

  void messaging() {
    var id = Get.parameters['id'];

    database.select(database.messageTable)
      ..where((value) => value.chat_id.equals(id!))
      ..limit(limit)
      ..orderBy([
        (m) => drift.OrderingTerm(
              expression: m.sent_at,
              mode: drift.OrderingMode.desc,
            ),
      ])
      ..watch().listen((value) => handleMessages(value));
  }

  void loadMessages() async {
    if (loading || ended) return;

    loading = true;

    var id = Get.parameters['id'];
    var last = messages.last;

    if (last == null) return;

    log('[chat.controller.dart] load messages before ${last.sentAt.toString()}');

    var value = await (database.select(database.messageTable)
          ..where((value) =>
              value.chat_id.equals(id!) &
              value.sent_at.isSmallerOrEqualValue(last.sentAt))
          ..limit(limit)
          ..orderBy([
            (m) => drift.OrderingTerm(
                  expression: m.sent_at,
                  mode: drift.OrderingMode.desc,
                ),
          ]))
        .get();

    loading = false;

    if (value.length < limit) {
      ended = true;
    }

    print(value.length);

    handleMessages(value);
  }

  void handleMessages(List<MessageTableData> value) {
    for (var val in value) {
      // check message id exists or no
      var id = '';

      if (val.local_id != '-1') {
        id = val.local_id!;
      } else if (val.id != null || val.id!.isNotEmpty) {
        id = val.id!;
      }

      if (id.isNotEmpty) {
        if (val.status == "deleted") {
          if (message[id] != null) {
            // delete message from map
            message.remove(id);
          }
        } else {
          print(val.data);
          message[id] = ChatMessageModel.fromDatabase(val);
        }
      }
    }

    update();
  }

  void childing() {
    children = [];

    // check user profile phone number is verified
    // if (Services.profile.profile.value.verified != true) {
    children.add(ChatCardVerifyWidget(onChange: childing));
    // }

    update();
  }

  void block() async {
    relation.value = relation.value.copyWith({"blocked": true});

    var id = Get.parameters['id']!;

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.BLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر به بلاکی ها اضافه شد');
      }
    });
  }

  void unblock() async {
    relation.value = relation.value.copyWith({"blocked": false});

    var id = Get.parameters['id']!;

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: id,
        action: RELATION_ACTION.UNBLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر از بلاکی ها حذف شد');
      }
    });
  }

  void favorite() async {
    relation.value = relation.value.copyWith({"favorited": true});

    var id = Get.parameters['id']!;

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

  void disfavorite() async {
    relation.value = relation.value.copyWith({"favorited": false});

    var id = Get.parameters['id']!;

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

  void report({
    required String fullname,
  }) {
    var id = Get.parameters['id'];

    Get.toNamed(
      '/app/report',
      arguments: {
        'id': id,
        'fullname': fullname,
      },
    );
  }

  void delete() async {
    // confirm
    var result = await Get.dialog(DialogDeleteChatView());

    if (result) {
      // delete all chats and delete chat
      var id = Get.parameters['id']!;
      await Services.chat.deleteChat(chatId: id);
      Get.back();
    }
  }
}
