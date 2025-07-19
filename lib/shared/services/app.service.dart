import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/firebase.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/foundation.dart';
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

    if (!kIsWeb) {
      await Services.firebase.event(type: FIREBASE_EVENT_TYPE.LOGOUT);
    }
    await ApiService.user.logout();

    await Future.wait([
      Services.configs.clear(),
      database.deleteEverything(),
    ]);

    Services.event.fire(event: EVENTS.LOGOUT);
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
