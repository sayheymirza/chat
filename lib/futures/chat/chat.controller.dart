import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_delete_chat/dialog_delete_chat.view.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/widgets/chat/chat_card/chat_card_verify.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<Relation> relation = Relation.empty.obs;

  List<Widget> children = [];

  Map<String, ChatMessageModel> message = {};
  List<ChatMessageModel> get messages => message.values.toList();

  StreamController<ChatModel> chatStream = StreamController<ChatModel>();

  int page = 0;
  int limit = 20;
  bool ended = false;
  bool loading = false;

  @override
  void onInit() {
    super.onInit();

    // save chat id to storage
    Services.configs.set(
      key: CONSTANTS.CURRENT_CHAT,
      value: Get.parameters['id'],
    );

    load();
  }

  @override
  void dispose() {
    super.dispose();

    Services.configs.unset(key: CONSTANTS.CURRENT_CHAT);
  }

  Future<void> load() async {
    try {
      listenChat();
      listenMessages();
      childing();
    } catch (e) {
      print(e);
    }
  }

  void listenChat() async {
    var id = Get.parameters['id'];

    var stream = await Services.chat.stream(chatId: id!);

    stream.listen((value) {
      if (value == null) {
        // destroy
        Get.back();

        return;
      }

      chatStream.add(value);
    });
  }

  void listenMessages() async {
    var id = Get.parameters['id'];

    var stream = Services.message.stream(chatId: id!);

    stream.listen((value) {
      handleMessages(value);
    });
  }

  void loadMessages() async {
    if (loading || ended) return;

    loading = true;

    var id = Get.parameters['id'];
    var last = messages.last;

    if (last == null) return;

    log('[chat.controller.dart] load messages before ${last.sentAt.toString()}');
  }

  void handleMessages(List<MessageTableData> value) {
    for (var val in value) {
      // check message id exists or no
      var id = '';

      if (val.local_id != '-1') {
        id = val.local_id!;
      } else if (val.message_id != null || val.message_id!.isNotEmpty) {
        id = val.message_id!;
      } else {
        id = val.id.toString();
      }

      if (id.isNotEmpty) {
        if (val.status == "deleted") {
          if (message[id] != null) {
            // delete message from map
            message.remove(id);
          }
        } else {
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
      Services.chat.delete(chatId: id);
      Services.message.deleteByChatId(chatId: id);
      Get.back();
    }
  }
}
