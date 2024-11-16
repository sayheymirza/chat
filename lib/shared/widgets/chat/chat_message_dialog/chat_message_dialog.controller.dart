import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class ChatMessageDialogController extends GetxController {
  void deleteForMe({required String messageId}) async {
    await Services.chat.deleteMessage(messageId: messageId);
    Get.back();
  }

  void deleteForAll({required String messageId}) async {
    await Services.chat.deleteMessage(messageId: messageId);
    Get.back();
  }

  void cancelSend({required String localId}) async {
    await Services.chat.cancelMessage(localId: localId);
    Get.back();
  }

  void send({required String localId}) async {
    await Services.chat.sendByLocalId(localId: localId);
    Get.back();
  }

  void download({
    required String url,
    required String category,
  }) {
    Services.file.download(
      url: url,
      category: category,
    );
    Get.back();
  }
}
