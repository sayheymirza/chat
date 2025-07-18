import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const EmojiRegex =
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

class ChatMessageTextV1Widget extends StatefulWidget {
  final ChatMessageModel message;
  final bool action;

  const ChatMessageTextV1Widget({
    super.key,
    required this.message,
    this.action = true,
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
      action: widget.action,
      message: widget.message,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        child: widget.message.data['markdown'] == true
            ? Column(
                children: widget.message.data['text']
                    .toString()
                    .split('\n')
                    .map((text) {
                  return Markdown(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    data: text.trim(),
                    selectable: false,
                    physics: NeverScrollableScrollPhysics(),
                    // data: widget.message.data['text'].toString().trim(),
                  );
                }).toList(),
              )
            : textMessage(),
      ),
    );
  }

  Widget textMessage() {
    final text = widget.message.data['text'] as String;
    final spans = <TextSpan>[];
    final regex = RegExp(EmojiRegex);
    var lastMatchEnd = 0;

    // Find all emoji matches and split text accordingly
    regex.allMatches(text).forEach((match) {
      // Add non-emoji text before this match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(
            fontFamily: "YekanBakh",
            fontSize: 16,
          ),
        ));
      }

      // Add the emoji
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          fontFamily: "NotoColorEmoji",
          fontSize: 16,
        ),
      ));

      lastMatchEnd = match.end;
    });

    // Add any remaining non-emoji text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(
          fontFamily: "YekanBakh",
          fontSize: 16,
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }
}
