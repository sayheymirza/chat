import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatMessageNotSupportWidget extends StatelessWidget {
  const ChatMessageNotSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
