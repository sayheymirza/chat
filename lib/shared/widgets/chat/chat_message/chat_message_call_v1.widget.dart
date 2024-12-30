import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        padding: const EdgeInsets.only(left: 20),
        child: states(),
      ),
    );
  }

  Widget states() {
    var mode =
        widget.message.data['mode'] == 'video' ? 'تماس تصویری' : 'تماس صوتی';

    if (widget.message.data['state'] == "calling") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.call,
                color: Colors.green,
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'در حال تماس',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(5),
                  Text(
                    mode,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Gap(20),
              TextButton(
                onPressed: () {
                  // widget.message.data['state'] = "canceled";
                  // Services.message.update(message: widget.message);
                },
                child: Text(
                  'رد تماس',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const Gap(10),
              TextButton(
                onPressed: () {
                  Services.call.make(
                    mode: widget.message.data['mode'],
                    save: false,
                  );
                },
                child: Text(
                  'پاسخ',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Container();
  }
}
