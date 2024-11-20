import 'package:chat/models/chat/chat.message.dart';

class ChatMessageMapV1Model extends ChatMessageModel {
  late double lat;
  late double lon;
  late double zoom;
  late String url;

  ChatMessageMapV1Model({
    required super.sentAt,
    required this.url,
    required this.zoom,
    required this.lon,
    required this.lat,
    super.type = 'map@v1',
  });

  @override
  toData() {
    return {
      "url": url,
      "zoom": zoom,
      "lat": lat,
      "lon": lon,
    };
  }
}
