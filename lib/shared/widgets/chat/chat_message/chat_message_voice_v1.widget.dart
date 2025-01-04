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
  List<dynamic>? waveforms;

  @override
  void initState() {
    super.initState();

    var waveform = widget.message.data['waveforms'] ??
        widget.message.data['waveform'] ??
        [];

    if (waveform.isNotEmpty) {
      if (mounted) {
        waveforms = waveform;
        setState(() {});
      }
    }

    controller = PlayerController(onStateChange: () {
      if (mounted) {
        setState(() {});
      }
    });

    controller.load(
        url: widget.message.data['url'],
        message: widget.message,
        onLoad: (file) async {
          if (waveforms != null && waveforms!.isNotEmpty) return;

          try {
            var result = await Services.waveframe.process(path: file.path);

            if (result != null && mounted) {
              setState(() {
                waveforms = result;
              });
            }
          } catch (e) {
            print(e);
          }
        });

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

  void upload() async {
    // start uploading
    await Services.file.upload(
      file: File(widget.message.data['url']),
      category: 'voice',
      meta: widget.message.toJson(),
      cache: true,
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
        waveforms: waveforms ?? [],
      ),
    );
  }

  Widget child({required List<dynamic> waveforms}) {
    bool me = widget.message.senderId == Services.profile.profile.value.id! ||
        widget.message.senderId!.isEmpty;

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
                  inactiveColor: me ? Colors.grey.shade400 : Colors.white70,
                  waveframe: waveforms,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        controller.passedTime == '00:00'
                            ? controller.totalTime
                            : controller.passedTime,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      const Gap(4),
                      Icon(
                        Icons.mic_rounded,
                        size: 14,
                      ),
                    ],
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
