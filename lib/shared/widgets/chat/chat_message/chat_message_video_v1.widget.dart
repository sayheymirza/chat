import 'dart:io';

import 'package:chat/abstracts/controllers/player.controller.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player_control_panel/video_player_control_panel.dart';

class ChatMessageVideoV1Widget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageVideoV1Widget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageVideoV1Widget> createState() =>
      _ChatMessageVideoV1WidgetState();
}

class _ChatMessageVideoV1WidgetState extends State<ChatMessageVideoV1Widget> {
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
  void didUpdateWidget(covariant ChatMessageVideoV1Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  @override
  void dispose() {
    super.dispose();

    controller.unload();
  }

  void init() {
    upload();
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
        category: 'video',
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
      child: child(url: widget.message.data['url']),
    );
  }

  Widget child({required String url}) {
    return controller.controller == null ||
            !controller.controller!.value.isInitialized
        ? Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            constraints: BoxConstraints.loose(Size(300, 600)),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: AspectRatio(
              aspectRatio: controller.controller!.value.aspectRatio,
              child: JkVideoControlPanel(
                controller.controller!,
                showClosedCaptionButton: false,
                showVolumeButton: true,
              ),
            ),
          );
  }
}
