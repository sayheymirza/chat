import 'package:chat/models/chat/chat.message.dart';

class ChatMessageVideoV1Model extends ChatMessageModel {
  late String url;
  late int size;
  late String name;
  late int duration;

  ChatMessageVideoV1Model({
    required super.sentAt,
    required this.url,
    required this.size,
    required this.name,
    required this.duration,
    super.type = 'video@v1',
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
