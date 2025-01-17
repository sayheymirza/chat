import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatMessageCallV1Widget extends StatefulWidget {
  final ChatMessageModel message;
  final bool action;

  const ChatMessageCallV1Widget({
    super.key,
    required this.message,
    this.action = true,
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
      action: widget.action,
      message: widget.message,
      child: Container(
        width: 250,
        padding: const EdgeInsets.only(left: 20),
        child: states(),
      ),
    );
  }

  Widget states() {
    var mode =
        widget.message.data['mode'] == 'video' ? 'تماس تصویری' : 'تماس صوتی';
    var state = widget.message.data['state'];

    if (state == "missed") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.call_rounded,
                  color: Colors.yellow.shade600,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تماس از دست رفته',
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
        ],
      );
    }

    if (state == "declined") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رد تماس',
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
        ],
      );
    }

    if(state == "answered") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.phone_callback,
                  color: Colors.green,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تماس دریافتی',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(5),
                  Row(
                    children: [
                      Text(
                        mode,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        widget.message.data['duration'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    if (state == "calling") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.call,
                  color: Colors.green,
                ),
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
        ],
      );
    }

    return Container();
  }
}
