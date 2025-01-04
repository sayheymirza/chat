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
    if (widget.message.status == "unknown") {
      upload();
    }
  }

  void upload() async {
    // start uploading
    await Services.file.upload(
      file: File(widget.message.data['url']),
      category: 'video',
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
