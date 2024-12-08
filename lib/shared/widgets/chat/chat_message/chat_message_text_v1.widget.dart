import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';

class ChatMessageTextV1Widget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageTextV1Widget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageTextV1Widget> createState() =>
      _ChatMessageTextV1WidgetState();
}

class _ChatMessageTextV1WidgetState extends State<ChatMessageTextV1Widget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageTextV1Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  void init() {
    if (widget.message.status == "unknown") {
      // send
      widget.message.status = "sending";
      Services.message.update(message: widget.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatMessageWidget(
      message: widget.message,
      child: Text(
        widget.message.data['text'],
      ),
    );
  }
}
