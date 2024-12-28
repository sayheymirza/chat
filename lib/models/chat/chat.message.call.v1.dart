import 'package:chat/models/chat/chat.message.dart';

class ChatMessageCallV1Model extends ChatMessageModel {
  late String state;
  late String mode;
  late String duration;
  late bool canJoin;

  ChatMessageCallV1Model({
    required this.state,
    required this.mode,
    required this.duration,
    required this.canJoin,
    super.type = 'call@v1',
    super.status = "sending",
  });

  @override
  toData() {
    return {
      'state': state,
      'mode': mode,
      'duration': duration,
      'can_join': canJoin,
      'type': type,
      'status': status,
    };
  }
}
