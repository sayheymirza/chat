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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminChatController extends GetxController {
  Rx<Relation> relation = Relation.empty.obs;

  List<Widget> children = [];

  List<ChatMessageModel> messages = [];

  StreamController<List<ChatMessageModel>> messageStream =
      StreamController<List<ChatMessageModel>>();
  StreamController<ChatModel> chatStream = StreamController<ChatModel>();

  CancelToken cancelToken = CancelToken();
  Timer? updateTimeout;

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

    cancelToken.cancel();

    chatStream.close();
  }

  Future<void> load() async {
    try {
      sync();
      listenChat();
      listenMessages();
      childing();
    } catch (e) {
      print(e);
    }
  }

  Future<void> sync() async {
    var id = Get.parameters['id'];

    await Services.message.syncAPIWithDatabase(
      chatId: id!,
      cancelToken: cancelToken,
    );
  }

  void listenChat() async {
    var id = Get.parameters['id'];

    var stream = await Services.adminChat.stream(chatId: id!);

    var subchat = stream.listen((value) {
      if (value == null) {
        // destroy
        Get.back();

        return;
      }

      chatStream.add(value);
    });

    chatStream.onCancel = () {
      subchat.cancel();
    };
  }

  void listenMessages() async {
    var id = Get.parameters['id'];

    var stream = Services.message.stream(chatId: id!, limit: 100);

    var submessages = stream.listen((value) {
      handleMessages(value);
    });

    var subsending = Services.message.listenToSending(chatId: id);

    chatStream.onCancel = () {
      subsending.cancel();
      submessages.cancel();
    };
  }

  void loadMessages() async {
    if (loading || ended) return;

    var id = Get.parameters['id'];
    var last = messages.last;

    if (last == null) return;

    log('[chat.controller.dart] load messages before ${last.sentAt.toString()}');

    try {
      loading = true;

      var result = await Services.message.select(
        chatId: id!,
        sentAt: last.sentAt!,
        limit: 100,
      );

      loading = false;

      if (result.isEmpty) {
        ended = true;
        return;
      }

      handleMessages(result);
    } catch (e) {
      loading = false;
    }
  }

  void handleMessages(List<MessageTableData> value) {
    for (var val in value) {
      var message = ChatMessageModel.fromDatabase(val);

      if (messages.isNotEmpty) {
        var index = -1;
        for (var i = messages.length - 1; i >= 0; i--) {
          if (messages[i].localId == val.local_id ||
              (messages[i].messageId == val.message_id &&
                  val.message_id != null)) {
            index = i;
            break;
          }
        }

        if (index == -1) {
          // messages.insert(0, message);
          messages.add(message);
        } else {
          messages[index] = message;
        }
      } else {
        messages.add(message);
      }
    }

    updateMessages();
  }

  void updateMessages() {
    if (updateTimeout != null && updateTimeout!.isActive) {
      updateTimeout!.cancel();
    }

    updateTimeout = Timer(Duration(milliseconds: 300), () {
      log('[chat.controller.dart] update message stream');
      messageStream
          .add(messages..sort((a, b) => a.sentAt!.compareTo(b.sentAt!)));
    });
  }

  void childing() {
    children = [];

    // check user profile phone number is verified
    if (Services.profile.profile.value.verified != true) {
      children.add(ChatCardVerifyWidget(onChange: childing));
    }

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
      var result = await ApiService.chat.deleteChatWithChatId(chatId: id);
      if (result) {
        Get.back();
        showSnackbar(message: 'چت شما حذف شد');
      } else {
        showSnackbar(message: 'خطا در حذف چت رخ داد');
      }
    }
  }
}
