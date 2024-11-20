import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class ChatMessageDialogController extends GetxController {
  void deleteForMe({required String messageId}) async {
    Services.message.deleteByMessageId(messageId: messageId, forAll: false);
    Get.back();
  }

  void deleteForAll({required String messageId}) async {
    Services.message.deleteByMessageId(messageId: messageId, forAll: true);
    Get.back();
  }

  void cancelSend({required String localId}) async {
    Services.message.deleteByLocalId(localId: localId);
    Get.back();
  }

  void send({required String localId}) async {
    Services.message.sendByLocalId(localId: localId);
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
