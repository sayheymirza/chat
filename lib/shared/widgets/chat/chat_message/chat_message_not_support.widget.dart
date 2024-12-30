import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatMessageNotSupportWidget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageNotSupportWidget({super.key, required this.message});

  @override
  State<ChatMessageNotSupportWidget> createState() =>
      _ChatMessageNotSupportWidgetState();
}

class _ChatMessageNotSupportWidgetState
    extends State<ChatMessageNotSupportWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageNotSupportWidget oldWidget) {
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
      color: Colors.red.withAlpha(64),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
          ),
          const Gap(8),
          Text(
            'این نوع پیام در حال حاظر پشتیبانی نمی شود',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
