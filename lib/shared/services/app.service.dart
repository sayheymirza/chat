import 'package:chat/app/apis/api.dart';
import 'package:chat/models/firebase.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class AppService extends GetxService {
  Future<void> handshake() async {
    var result = await ApiService.data.handshake();

    if (result != null) {
      // store plans
      Services.configs.set(
        key: CONSTANTS.STROAGE_PLANS,
        value: result.plans.map((element) => element.toJson()).toList(),
      );
      // store each config
      Services.configs.setFromMap(result.configs);
    }
  }

  Future<void> logout() async {
    ApiService.socket.disconnect();

    await Services.firebase.event(type: FIREBASE_EVENT_TYPE.LOGOUT);
    await ApiService.user.logout();

    await Future.wait([
      Services.configs.unset(key: CONSTANTS.STORAGE_ACCESS_TOKEN),
      Services.configs.unset(key: CONSTANTS.STORAGE_FIREBASE_TOKEN),
      Services.chat.clear(),
      Services.adminChat.clear(),
      Services.message.clear(),
      Services.sync.clear(),
      Services.log.clear(),
    ]);
  }

  Future<void> copy(String value) async {
    await Clipboard.setData(
      ClipboardData(text: value),
    );
  }

  Future<void> share(String value) async {
    await Share.share(value);
  }
}
