import 'package:chat/models/chat/chat.message.dart';

class ChatMessageImageV1Model extends ChatMessageModel {
  late String url;
  late int size;

  ChatMessageImageV1Model({
    required super.sentAt,
    required this.url,
    required this.size,
    super.type = 'image@v1',
  });

  @override
  toData() {
    return {
      "url": url,
      "size": size,
    };
  }
}
