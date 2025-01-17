import 'dart:io';

import 'package:chat/futures/dialog_image/dialog_image.view.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessageImageV1Widget extends StatefulWidget {
  final ChatMessageModel message;
  final bool action;

  const ChatMessageImageV1Widget({
    super.key,
    required this.message,
    this.action = true,
  });

  @override
  State<ChatMessageImageV1Widget> createState() =>
      _ChatMessageImageV1WidgetState();
}

class _ChatMessageImageV1WidgetState extends State<ChatMessageImageV1Widget> {
  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageImageV1Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
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
      category: 'image',
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
      action: widget.action,
      message: widget.message,
      child: child(
        url: widget.message.data['url'],
      ),
    );
  }

  Widget child({
    required String url,
  }) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          DialogImageView(
            url: url,
          ),
          useSafeArea: false,
        );
      },
      child: Container(
        width: 300,
        height: 300,
        padding: EdgeInsets.all(0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            if (url != null && !url.startsWith('http'))
              Positioned(
                top: -16,
                left: -16,
                right: -16,
                bottom: -16,
                child: Image.file(
                  File(url),
                  fit: BoxFit.cover,
                ),
              ),
            if (url != null && url.startsWith('http'))
              Positioned(
                top: -16,
                left: -16,
                right: -16,
                bottom: -16,
                child: CachedImageWidget(
                  url: url,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
