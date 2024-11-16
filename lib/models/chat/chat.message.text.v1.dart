import 'package:chat/models/chat/chat.message.dart';

class ChatMessageTextV1Model extends ChatMessageModel {
  late String text;

  ChatMessageTextV1Model({
    required super.sentAt,
    required this.text,
    super.id = "",
    super.localId = "",
    super.chatId = "",
    super.senderId = "",
    super.type = 'text@v1',
    super.status = "sending",
  });

  @override
  toData() {
    return {
      "text": text,
    };
  }
}
