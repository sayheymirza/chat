import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_delete_chat/dialog_delete_chat.view.dart';
import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.call.v1.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/widgets/chat/chat_card/chat_card_plan.widget.dart';
import 'package:chat/shared/widgets/chat/chat_card/chat_card_verify.widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxBool makingCall = false.obs;

  Rx<ChatModel> chat = ChatModel().obs;

  List<Widget> children = [];

  RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  StreamSubscription<EventModel>? subevents;
  StreamSubscription<ChatModel?>? subchat;

  // StreamSubscription<List<MessageTableData>>? subsending;

  CancelToken cancelToken = CancelToken();

  Timer? updateTimeout;
  Timer? syncTimeout;

  bool ended = false;
  bool loading = false;

  String? chatId;

  @override
  void onInit() {
    super.onInit();

    // save chat id to storage
    Services.configs.set(
      key: CONSTANTS.CURRENT_CHAT,
      value: Get.parameters['id'],
    );

    chatId = Get.parameters['id'];

    load();

    subevents = event.on<EventModel>().listen((data) async {
      onEvent(event: data.event, data: data.value);
    });
  }

  @override
  void dispose() {
    log('[chat.controller.dart] dispose');

    unload();

    super.dispose();
  }

  @override
  void onClose() {
    log('[chat.controller.dart] on close');

    unload();

    super.onClose();
  }

  void onEvent({
    required String event,
    required dynamic data,
  }) async {
    if (event == MESSAGE_EVENTS.DELETE_LOCAL_MESSAGE) {
      var id = data;

      // find and remove it
      var index = messages.indexWhere((element) => element.localId == id);

      if (index != -1) {
        messages.removeAt(index);
      }
    }

    if (event == MESSAGE_EVENTS.UPDATE_MESSAGE ||
        event == MESSAGE_EVENTS.ADD_MESSAGE) {
      data = ChatMessageModel.fromDatabase(data);

      // find and update it
      var index = -1;
      for (var i = messages.length - 1; i >= 0; i--) {
        if (messages[i].localId == data.localId ||
            (messages[i].messageId == data.messageId &&
                data.messageId != null)) {
          index = i;
          break;
        }
      }

      if (index != -1) {
        messages[index] = data;
      } else {
        messages.add(data);
      }

      if (data.status == "sending") {
        Services.message.send(message: data);
      }
    }
  }

  Future<void> unload() async {
    log('[chat.controller.dart] unload');

    Services.configs.unset(key: CONSTANTS.CURRENT_CHAT);

    cancelToken.cancel();

    subevents?.cancel();
    subchat?.cancel();

    updateTimeout?.cancel();
    syncTimeout?.cancel();
  }

  Future<void> load() async {
    try {
      sync();
      listenChat();
      listenMessages();
      fetch();
      markAllAsSeen();
    } catch (e) {
      print(e);
    }
  }

  Future<void> sync() async {
    var id = chatId!;

    var last = await Services.message.lastByChatId(chatId: id);
    var page = 1;

    do {
      var result = await Services.message.syncAPIWithDatabase(
        chatId: id,
        seq: last?.seq,
        operator: ApiChatMessageOperator.AFTER,
        page: page,
      );

      if (result.isEmpty) {
        break;
      }

      page++;

      handleMessages(result);
    } while (true);

    // sync messages before last message for 2 pages
    page = 1;

    do {
      var result = await Services.message.syncAPIWithDatabase(
        chatId: id,
        seq: last?.seq,
        operator: ApiChatMessageOperator.BEFORE,
        page: page,
      );

      if (result.isEmpty) {
        break;
      }

      page++;

      handleMessages(result);

      if (page > 2) {
        break;
      }
    } while (true);
  }

  Future<void> markAllAsSeen() {
    return Services.chat.see(chatId: chatId!);
  }

  Future<void> fetch() async {
    await Future.wait([
      // fetchUser(),
      fetchChat(),
    ]);
    // syncTimeout = Timer(Duration(seconds: 5), () {
    //   fetch();
    // });
  }

  Future<void> fetchUser() async {
    if (chat.value.userId != null) {
      await Services.user.fetch(userId: chat.value.userId!);
    }
  }

  Future<void> fetchChat() async {
    var id = chatId;

    await Services.chat.one(chatId: id!);
  }

  void listenChat() async {
    var id = chatId;

    var stream = await Services.chat.stream(chatId: id!);

    subchat = stream.listen((value) {
      if (value == null) {
        // destroy
        Get.back();

        return;
      }

      log('[chat.controller.dart] chat info updated');
      chat.value = value;
      childing();
    });
  }

  void listenMessages() async {
    var id = Get.parameters['id'];

    // select last 50 messages
    var data = await Services.message.select(
      chatId: id!,
    );

    handleMessages(data);

    // var limit = 50;
    //
    // var stream = Services.message.stream(chatId: id!, limit: limit);
    //
    // var submessages = stream.listen((value) {
    //   print(value.length);
    //   if (limit == 0) {
    //     messageStream.add(
    //       value.map((elem) => ChatMessageModel.fromDatabase(elem)).toList(),
    //     );
    //   } else {
    //     handleMessages(value);
    //   }
    // });
    //
    // subsending = Services.message.listenToSending(chatId: id);
  }

  void loadMessages() async {
    if (loading || ended) return;

    var id = chatId;
    var last = messages.first;

    if (last == null) return;

    log('[chat.controller.dart] load messages before ${last.seq}');

    try {
      loading = true;

      var result = await Services.message.select(
        chatId: id!,
        seq: last.seq!,
        limit: 20,
      );

      if (result.isEmpty) {
        var fetchedResult = await Services.message.syncAPIWithDatabase(
          chatId: id,
          seq: last.seq!,
          limit: 100,
        );

        if (fetchedResult.isEmpty) {
          ended = true;
          return;
        }
      }

      loading = false;

      handleMessages(result);
    } catch (e) {
      loading = false;
    }
  }

  void handleMessages(List<MessageTableData> value) {
    for (var val in value) {
      var data = ChatMessageModel.fromDatabase(val);

      var index = -1;
      for (var i = messages.length - 1; i >= 0; i--) {
        if (messages[i].localId == data.localId ||
            (messages[i].messageId == data.messageId &&
                data.messageId != null)) {
          index = i;
          break;
        }
      }

      if (index != -1) {
        messages[index] = data;
      } else {
        messages.add(data);
      }
    }

    updateMessages();
  }

  void updateMessages() {
    if (updateTimeout != null && updateTimeout!.isActive) {
      updateTimeout!.cancel();
    }

    updateTimeout = Timer(Duration(milliseconds: 100), () {
      log('[chat.controller.dart] update message stream');
      // messageStream.add(messages..sort((a, b) => a.seq!.compareTo(b.seq!)));
      messages = messages..sort((a, b) => a.seq!.compareTo(b.seq!));
      update();
    });
  }

  void childing() {
    children = [];

    // check user profile phone number is verified
    if (chat.value.permission.contains('CARD_CONFIRM_PHONE')) {
      children.add(ChatCardVerifyWidget(onChange: childing));
    }

    if (chat.value.permission.contains('CARD_NEED_PLAN')) {
      children.add(ChatCardPlanWidget(userId: chat.value.userId!));
    }

    update();
  }

  void block() async {
    if (chat.value.userId == null) return;

    // relation.value = relation.value.copyWith({"blocked": true});
    await Services.user.relation(
      userId: chat.value.userId!,
      action: RELATION_ACTION.BLOCK,
    );

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: chat.value.userId!,
        action: RELATION_ACTION.BLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر به بلاکی ها اضافه شد');
        fetchUser();
      }
    });
  }

  void unblock() async {
    if (chat.value.userId == null) return;

    // relation.value = relation.value.copyWith({"blocked": false});

    // update user id relation blocked to false from database
    await Services.user.relation(
      userId: chat.value.userId!,
      action: RELATION_ACTION.UNBLOCK,
    );

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: chat.value.userId!,
        action: RELATION_ACTION.UNBLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر از بلاکی ها حذف شد');
        fetchUser();
      }
    });
  }

  void report() {
    if (chat.value.userId == null) return;

    Get.toNamed(
      '/app/report',
      arguments: {
        'id': chat.value.userId!,
        'fullname': chat.value.user!.fullname,
      },
    );
  }

  void delete() async {
    // confirm
    var result = await Get.dialog(DialogDeleteChatView());

    if (result) {
      // delete all chats and delete chat
      var id = chatId!;
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
