import 'dart:io';

import 'package:chat/abstracts/controllers/player.controller.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatMessageAudioV1Widget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageAudioV1Widget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageAudioV1Widget> createState() =>
      _ChatMessageAudioV1WidgetState();
}

class _ChatMessageAudioV1WidgetState extends State<ChatMessageAudioV1Widget> {
  var controller = ChatMessageVoiceV1Controller();

  @override
  void initState() {
    super.initState();

    controller.load(url: widget.message.data['url']);

    if (widget.message.status == "unknown") {
      upload();
    }
  }

  void upload() async {
    // start uploading
    var result = await Services.file.upload(
        file: File(widget.message.data['url']),
        category: 'audio',
        onUploading: ({int percent = 0, int total = 0, int sent = 0}) {
          widget.message.status = "uploading";
          widget.message.meta = {
            'percent': percent,
            'total': total,
            'sent': sent,
          };
          setState(() {});
        });

    if (result != null && result.done) {
      widget.message.data['url'] = result.url;
      widget.message.data['file_id'] = result.fileId;
      widget.message.status = "sending";

      Services.message.send(message: widget.message);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatMessageWidget(
      message: widget.message,
      child: child(),
    );
  }

  Widget child() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // waveform widget or player
          SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                controller.seeker(
                  width: 210,
                  totalDuration: controller.totalDuration,
                  passedDuration: controller.passedDuration,
                  onSeek: (duration) {
                    controller.seek(duration);
                  },
                  inactiveColor: Colors.white.withAlpha(128),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    controller.passedTime == '00:00'
                        ? controller.totalTime
                        : controller.passedTime,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          controller.buttonPlay(
            playing: controller.playing,
            onToggle: () {
              controller.toggle();
            },
            radius: 10,
            color: Get.theme.primaryColor,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class ChatMessageVoiceV1Controller extends PlayerController {}
