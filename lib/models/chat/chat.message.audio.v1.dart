import 'package:chat/models/chat/chat.message.dart';

class ChatMessageAudioV1Model extends ChatMessageModel {
  late String url;
  late int size;
  late String name;
  late int duration;

  ChatMessageAudioV1Model({
    required super.sentAt,
    required this.url,
    required this.size,
    required this.name,
    required this.duration,
    super.id = "",
    super.localId = "",
    super.chatId = "",
    super.senderId = "",
    super.type = 'audio@v1',
  });

  @override
  toData() {
    return {
      "name": name,
      "duration": duration,
      "url": url,
      "size": size,
    };
  }
}
