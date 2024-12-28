import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';

class ChatMessageCallV1Widget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageCallV1Widget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageCallV1Widget> createState() =>
      _ChatMessageCallV1WidgetState();
}

class _ChatMessageCallV1WidgetState extends State<ChatMessageCallV1Widget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageCallV1Widget oldWidget) {
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
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        child: Row(
          children: [
            Column(),
          ],
        ),
      ),
    );
  }
}
