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
  late PlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = PlayerController(onStateChange: () {
      if (mounted) {
        setState(() {});
      }
    });
    controller.load(
      url: widget.message.data['url'],
      message: widget.message,
    );

    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageAudioV1Widget oldWidget) {
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

  void upload() async {
    // start uploading
    Services.file.upload(
      file: File(widget.message.data['url']),
      category: 'audio',
      meta: widget.message.toJson(),
      onError: (result) {
        if (result != null) {
          var message = ChatMessageModel.fromJson(result.meta);

          message.status = "unuploaded";
          message.meta = {};

          Services.message.update(message: message);
        }
      },
      onProgress: (result) {
        if (result != null) {
          var message = ChatMessageModel.fromJson(result.meta);

          message.status = "uploading";
          message.meta = {
            'percent': result.percent,
            'total': result.total,
            'sent': result.sentOrRecived,
          };

          Services.message.update(message: message);
        }
      },
      onDone: (result) {
        if (result != null && result.done) {
          var message = ChatMessageModel.fromJson(result.meta);

          message.data['url'] = result.url;
          message.data['file_id'] = result.fileId;
          message.status = "sending";

          Services.message.update(message: message);
        }
      },
    );
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
