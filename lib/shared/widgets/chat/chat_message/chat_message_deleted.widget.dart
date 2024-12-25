import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatMessageDeletedWidget extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageDeletedWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ChatMessageWidget(
      message: message,
      color: Colors.red.withAlpha(64),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
          const Gap(8),
          Text(
            'این پیام حذف شده است',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
