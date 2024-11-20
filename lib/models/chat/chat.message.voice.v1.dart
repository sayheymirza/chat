import 'package:chat/models/chat/chat.message.dart';

class ChatMessageVoiceV1Model extends ChatMessageModel {
  late String url;
  late int size;
  late int duration;
  late List<dynamic> waveform;

  ChatMessageVoiceV1Model({
    required super.sentAt,
    required this.url,
    required this.size,
    required this.duration,
    this.waveform = const [],
    super.type = 'voice@v1',
  });

  @override
  toData() {
    return {
      "duration": duration,
      "url": url,
      "size": size,
      "waveform": waveform,
    };
  }
}
