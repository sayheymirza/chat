import 'dart:io';

import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class ChatMessageController extends GetxController {
  void deleteForMe({required String messageId}) async {
    Services.message.deleteByMessageId(messageId: messageId, forAll: false);
  }

  void deleteForAll({required String messageId}) async {
    Services.message.deleteByMessageId(messageId: messageId, forAll: true);
  }

  void cancelSend({required String localId}) async {
    Services.message.deleteByLocalId(localId: localId);
  }

  void cancelUpload({required ChatMessageModel message}) {
    if (message.status == "uploading" &&
        message.data['url'] != null &&
        !message.data['url'].startsWith('http')) {
      var model = Services.file.getUploadByFile(File(message.data['url']));

      if (model != null) {
        model.cancelToken.cancel();
      }

      // change message status to unuploaded
      message.status = "unuploaded";
      Services.message.update(message: message);
    }
  }

  void send({required ChatMessageModel message}) async {
    // Services.message.sendByLocalId(localId: localId);
    message.status = "unknown";
    Services.message.update(message: message);
  }

  void download({
    required String url,
    required String category,
  }) {
    Services.file.download(
      url: url,
      category: category,
    );
  }
}
