import 'package:chat/models/chat/chat.message.dart';

class ChatMessageTextV1Model extends ChatMessageModel {
  late String text;

  ChatMessageTextV1Model({
    required this.text,
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
