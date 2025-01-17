import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_incoming_call/dialog_incoming_call.view.dart';
import 'package:chat/models/call.model.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class CallService extends GetxService {
  void close() {
    // if path is /app/call (pop or back)
    if (Get.currentRoute == '/app/call') {
      Get.back();
    }
  }

  void action({required String type, String? userId}) {
    var call = Services.configs.get(key: CONSTANTS.CALL_INCALL);

    ApiService.socket.send(
      event: CALL_EVENTS.ACTION,
      data: {
        'action': type,
        'user_id': userId ?? call['userId'] ?? call['user_id'],
      },
    );
  }

  void make({
    required String mode,
    required String chatId,
    required String userId,
  }) async {
    try {
      // checking user has permissions to mic and camera
      if (await Services.permission.has('mic') == false) {
        await Services.permission.ask('mic');
      }

      if (await Services.permission.has('camera') == false) {
        await Services.permission.ask('camera');
      }

      var result = await ApiService.chat.createCallToken(
        chatId: chatId,
        userId: userId,
        mode: mode,
        type: "START",
      );

      if (result.token == null) {
        showSnackbar(message: result.message);
        return;
      }

      Services.sound.play(type: 'dialing');

      await Get.toNamed(
        '/app/call',
        arguments: {
          'token': result.token,
          'mode': mode,
          'chatId': chatId,
          'userId': userId,
        },
      );

      Services.sound.stop(type: 'dialing');
    } catch (e) {
      print(e);
    }
  }

  Future<void> incoming({
    required IncomingCallModel call,
    required String chatId,
    required String userId,
  }) async {
    Services.sound.play(type: 'ringtone');

    Services.configs.set(key: CONSTANTS.CALL_INCOMMING, value: true);

    var answer = await Get.dialog(
      DialogIncomingCallView(call: call),
      useSafeArea: false,
    );

    Services.configs.set(key: CONSTANTS.CALL_INCOMMING, value: false);

    Services.sound.stop(type: 'ringtone');

    if (answer == true) {
      action(type: CALL_ACTIONS.ACCEPT, userId: userId);

      var result = await ApiService.chat.createCallToken(
        chatId: chatId,
        userId: userId,
        mode: call.mode,
        type: "ACCEPT",
      );

      if (result.token == null) {
        showSnackbar(message: result.message);
        return;
      }
      // checking user has permissions to mic and camera
      if (await Services.permission.has('mic') == false) {
        await Services.permission.ask('mic');
      }

      if (await Services.permission.has('camera') == false) {
        await Services.permission.ask('camera');
      }

      Get.toNamed(
        '/app/call',
        arguments: {
          'token': result.token,
          'mode': call.mode,
          'chatId': chatId,
          'userId': userId,
        },
      );

      return;
    } else {
      action(type: CALL_ACTIONS.DECLINE, userId: userId);
    }
  }
}
