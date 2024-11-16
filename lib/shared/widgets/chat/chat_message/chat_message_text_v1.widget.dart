import 'package:flutter/material.dart';

class ChatMessageTextV1Widget extends StatelessWidget {
  final String text;

  const ChatMessageTextV1Widget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }
}
