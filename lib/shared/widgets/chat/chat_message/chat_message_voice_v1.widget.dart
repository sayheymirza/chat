import 'dart:io';

import 'package:chat/abstracts/controllers/player.controller.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatMessageVoiceV1Widget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageVoiceV1Widget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageVoiceV1Widget> createState() =>
      _ChatMessageVoiceV1WidgetState();
}

class _ChatMessageVoiceV1WidgetState extends State<ChatMessageVoiceV1Widget> {
  late PlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = PlayerController(onStateChange: () {
      setState(() {});
    });
    controller.load(url: widget.message.data['url']);

    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageVoiceV1Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  @override
  void dispose() {
    super.dispose();

    controller.unload();
  }

  void init() {
    if (widget.message.status == "unknown") {
      upload();
    }
  }

  void setUploading({int percent = 0, int total = 0, int sent = 0}) {
    widget.message.status = "uploading";
    widget.message.meta = {
      'percent': percent,
      'total': total,
      'sent': sent,
    };
    setState(() {});
  }

  void upload() async {
    setUploading();
    // start uploading
    var result = await Services.file.upload(
        file: File(widget.message.data['url']),
        category: 'voice',
        onUploading: ({int percent = 0, int total = 0, int sent = 0}) {
          setUploading(
            percent: percent,
            total: total,
            sent: sent,
          );
        });

    if (result != null && result.done) {
      widget.message.data['url'] = result.url;
      widget.message.data['file_id'] = result.fileId;
      widget.message.status = "sending";

      Services.message.update(message: widget.message);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatMessageWidget(
      message: widget.message,
      child: child(
        waveforms: widget.message.data['waveforms'] ?? [],
      ),
    );
  }

  Widget child({required List<double> waveforms}) {
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
                  waveframe: waveforms,
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
