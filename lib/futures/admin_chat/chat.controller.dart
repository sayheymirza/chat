import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_delete_chat/dialog_delete_chat.view.dart';
import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/models/apis/socket.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
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
  StreamSubscription<EventModel>? subsocket;

  CancelToken cancelToken = CancelToken();
  Timer? updateTimeout;

  int page = 0;
  int limit = 20;
  bool ended = false;
  bool loading = false;

  String? userId;

  @override
  void onInit() {
    super.onInit();

    // save chat id to storage
    Services.configs.set(
      key: CONSTANTS.CURRENT_CHAT,
      value: Get.parameters['id'],
    );

    load();

    subsocket = event.on<EventModel>().listen((data) async {
      if (data.event == SOCKET_EVENTS.CONNECTED) {
        Services.message.sendAll();
      }

      if(data.event == "chat:delete-local-message") {
        var id = data.value;

        // find and remove it
        var index = messages.indexWhere((element) => element.localId == id);

        if(index != -1) {
          messages.removeAt(index);
          updateMessages();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    Services.configs.unset(key: CONSTANTS.CURRENT_CHAT);

    cancelToken.cancel();

    chatStream.close();
    messageStream.close();

    subsocket!.cancel();
  }

  Future<void> load() async {
    try {
      sync();
      listenChat();
      listenMessages();
      fetch();
      childing();
      markAllAsSeen();
    } catch (e) {
      print(e);
    }
  }

  Future<void> sync() async {
    var id = Get.parameters['id']!;

    var last = await Services.message.lastByChatId(chatId: id);

    if (last != null) {
      await Future.wait([
        Services.message.syncAPIWithDatabase(
          chatId: id,
          seq: last.seq!,
          operator: ApiChatMessageOperator.AFTER,
        ),
        Services.message.syncAPIWithDatabase(
          chatId: id,
          seq: last.seq!,
          operator: ApiChatMessageOperator.BEFORE,
        ),
      ]);
    }
  }

  Future<void> markAllAsSeen() {
    return Services.chat.see(chatId: Get.parameters['id']!);
  }

  Future<void> fetch() async {
    await Future.wait([
      fetchUser(),
      fetchChat(),
    ]);
  }

  Future<void> fetchUser() async {
    if (userId != null) {
      await Services.user.fetch(userId: userId!);
      childing();
    }
  }

  Future<void> fetchChat() async {
    var id = Get.parameters['id'];

    await Services.chat.one(chatId: id!);
  }

  void listenChat() async {
    var id = Get.parameters['id'];

    var stream = await Services.chat.stream(chatId: id!);

    var subchat = stream.listen((value) {
      if (value == null) {
        // destroy
        Get.back();

        return;
      }

      chatStream.add(value);

      userId = value.userId!;

      relation.value = value.user!.relation!;
      update();
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

    messageStream.onCancel = () {
      subsending.cancel();
      submessages.cancel();
    };
  }

  void loadMessages() async {
    if (loading || ended) return;

    var id = Get.parameters['id'];
    var last = messages.last;

    if (last == null) return;

    log('[chat.controller.dart] load messages before ${last.seq}');

    try {
      loading = true;

      var result = await Services.message.select(
        chatId: id!,
        seq: last.seq!,
        limit: 100,
      );

      if (result.isEmpty) {
        var fetchedResult = await Services.message.syncAPIWithDatabase(
          chatId: id,
          seq: last.seq!,
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
          messages.insert(0, message);
          // messages.add(message);
        } else {
          messages[index] = message;
        }
      } else {
        messages.insert(0, message);
        // messages.add(message);
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
    if (userId == null) return;

    relation.value = relation.value.copyWith({"blocked": true});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: userId!,
        action: RELATION_ACTION.BLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر به بلاکی ها اضافه شد');
        fetchUser();
      }
    });
  }

  void unblock() async {
    if (userId == null) return;

    relation.value = relation.value.copyWith({"blocked": false});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: userId!,
        action: RELATION_ACTION.UNBLOCK,
      );
      if (result) {
        showSnackbar(message: 'کاربر از بلاکی ها حذف شد');
        fetchUser();
      }
    });
  }

  void favorite() async {
    if (userId == null) return;

    relation.value = relation.value.copyWith({"favorited": true});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: userId!,
        action: RELATION_ACTION.FAVORITE,
      );
      if (result) {
        showSnackbar(message: 'کاربر به علاقه مندی ها اضافه شد');
      }
    });
  }

  void disfavorite() async {
    if (userId == null) return;

    relation.value = relation.value.copyWith({"favorited": false});

    Services.queue.add(() async {
      var result = await ApiService.user.react(
        user: userId!,
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
    if (userId == null) return;

    Get.toNamed(
      '/app/report',
      arguments: {
        'id': userId!,
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
