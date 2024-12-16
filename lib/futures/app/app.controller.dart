import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/app/apis/socket.dart';
import 'package:chat/models/apis/socket.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/chat.service.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  ChatService get chat => Get.find(tag: 'chat');

  SocketService get socket => Get.find(tag: 'api:socket');

  RxInt view = 0.obs;

  @override
  void onInit() {
    super.onInit();

    Services.profile.fetchMyProfile();

    Services.chat.listenToEvents();
    Services.message.listenToEvents();

    socket.connect();

    event.on<EventModel>().listen((data) async {
      if (data.event == SOCKET_EVENTS.CONNECTED) {
        Services.message.sendAll();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    ApiService.socket.disconnect();
  }

  void setView(int value) {
    view.value = value;
    log('[app.controller.dart] view changed to $value');
  }
}
