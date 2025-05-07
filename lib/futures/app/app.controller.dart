import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/app/apis/socket.dart';
import 'package:chat/models/apis/socket.model.dart';
import 'package:chat/models/call.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/vibration.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class AppController extends GetxController {
  SocketService get socket => Get.find(tag: 'api:socket');
  StreamSubscription<EventModel>? subevents;

  RxInt view = 0.obs;

  bool purchasing = false;
  List<int> viewsHistory = [];

  @override
  void onInit() {
    super.onInit();

    Services.notification.join();

    Services.profile.fetchMyProfile();
    Services.app.handshake();

    Services.adminChat.listenToEvents();
    Services.chat.listenToEvents();
    Services.message.listenToEvents();

    Services.notification.init();
    Services.notification.ask();

    socket.connect();
    socket.listen();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == SOCKET_EVENTS.CONNECTED) {
        Services.message.sendAll();
      }

      if (data.event == EVENTS.PURCHASE_NOT_CONSUMED_LIST) {
        consumeNotConsumedPurchase(purchases: data.value);
      }

      if (data.event == EVENTS.SOCKET_SEND_NOT_CONSUMED_PRODUCTS) {
        Services.event.fire(event: EVENTS.PURCHASE_NOT_CONSUMED);
      }

      if (data.event == EVENTS.SOCKET_CLEAR_CACHE) {
        Services.cache.delete();
      }

      if (data.event == EVENTS.SOCKET_CLEAR_DATABASE) {
        await Future.wait([
          Services.chat.clear(),
          Services.adminChat.clear(),
          Services.message.clear(),
          Services.sync.clear(),
        ]);
      }

      if (data.event == EVENTS.SOCKET_LOGOUT) {
        await Services.app.logout();

        Restart.restartApp();
      }

      if (data.event == EVENTS.SOCKET_REHANDSHAKE) {
        Services.app.handshake();
      }

      if (data.event == EVENTS.SOCKET_PROFILE_ME) {
        Services.profile.fetchMyProfile();
      }

      if (data.event == EVENTS.SOCKET_PROFILE_ID) {
        var userId = data.value['user_id'];

        if (userId != null) {
          Services.user.fetch(userId: userId);
        }
      }

      if (data.event == EVENTS.SOCKET_SNACKBAR) {
        var message = data.value['message'];

        if (message != null) {
          showSnackbar(message: message);
        }
      }

      if (data.event == EVENTS.SOCKET_ROUTE) {
        var path = data.value['path'];
        var aurguments = data.value['arguments'];
        var parameters = data.value['parameters'];

        if (path != null) {
          Get.toNamed(path, arguments: aurguments, parameters: parameters);
        }
      }

      if (data.event == EVENTS.SOCKET_ROUTE_BACK) {
        Get.back();
      }

      if (data.event == EVENTS.SOCKET_NOTIFICATION) {
        Services.notification.make(
          id: data.value['id'],
          title: data.value['title'],
          body: data.value['body'],
        );
      }

      if (data.event == EVENTS.SOCKET_SOUND_PLAY) {
        var type = data.value['type'];

        if (type != null) {
          Services.sound.play(type: type);
        }
      }

      if (data.event == EVENTS.SOCKET_SOUND_STOP) {
        var type = data.value['type'];

        if (type != null) {
          Services.sound.stop(type: type);
        }
      }

      if (data.event == EVENTS.SOCKET_VIBRATION) {
        var duration = data.value['duration'];

        if (duration != null) {
          vibrate(
            duration: duration ?? 100,
          );
        }
      }

      if (data.event == EVENTS.SOCKET_INCOMING_CALL) {
        Services.call.incoming(
          call: IncomingCallModel(
            avatar: data.value['avatar'],
            fullname: data.value['name'],
            mode: data.value['mode'],
          ),
          chatId: data.value['chat_id'].toString(),
          userId: data.value['user_id'].toString(),
        );
      }

      if (data.event == EVENTS.SOCKET_INCOMING_CALL_DECLINE) {
        return;
        Services.sound.stop(type: 'ringtone');
        Services.sound.play(type: 'beep-beep');
        Services.sound.stop(type: 'dialing');
        Services.call.close();
      }

      if (data.event == EVENTS.SOCKET_INCOMING_CALL_ACCEPT) {
        log('[app.controller.dart] incoming call accept');

        Services.sound.stop(type: 'ringtone');
        Services.sound.stop(type: 'dialing');
      }

      if (data.event == EVENTS.SOCKET_INCOMING_CALL_END) {
        return;
        Services.sound.stop(type: 'ringtone');
        Services.sound.stop(type: 'dialing');
        Services.call.close();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    subevents?.cancel();
  }

  void setView(int value) {
    viewsHistory.add(view.value);
    view.value = value;
    log('[app.controller.dart] view changed to $value');
  }

  void back() {
    var last = viewsHistory.removeLast();
    view.value = last;
    log('[app.controller.dart] view backed to $last');
  }

  Future<void> consumeNotConsumedPurchase({
    required List<EventParchaseResultModel> purchases,
  }) async {
    if (purchasing) return;

    purchasing = true;

    var packageInfo = await Services.access.generatePackageInfo();

    for (var purchase in purchases) {
      if (CONSTANTS.FLAVOR == "cafebazaar" && purchase.token != null) {
        await ApiService.purchase.consumeInvoiceWithCafebazaar(
          purchaseToken: purchase.token!,
          sku: purchase.sku,
          packageName: packageInfo.packageName,
        );
      }
    }

    purchasing = false;
  }
}
