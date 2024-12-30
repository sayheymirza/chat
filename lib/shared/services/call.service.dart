import 'package:chat/app/apis/api.dart';
import 'package:chat/models/chat/chat.message.call.v1.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class CallService extends GetxService {
  void make({
    required String mode,
    bool save = true,
  }) async {
    try {
      // checking user has permissions to mic and camera
      if (await Services.permission.has('mic') == false) {
        await Services.permission.ask('mic');
      }

      if (await Services.permission.has('camera') == false) {
        await Services.permission.ask('camera');
      }

      var chatId = Services.configs.get(key: CONSTANTS.CURRENT_CHAT);

      var result = await ApiService.chat.createCallToken(chatId: chatId!);

      if (result == null) {
        showSnackbar(message: 'خطا در ایجاد تماس');
        return;
      }

      if (save) {
        Services.message.save(
          message: ChatMessageCallV1Model(
            state: 'calling',
            mode: mode,
            duration: '',
            canJoin: true,
          ),
        );
      }

      Get.toNamed(
        '/app/call',
        arguments: {
          'token': result,
          'mode': mode,
          'chatId': chatId,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
