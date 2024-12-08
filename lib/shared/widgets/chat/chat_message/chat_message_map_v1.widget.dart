import 'dart:io';

import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:flutter/material.dart';

class ChatMessageMapV1Widget extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageMapV1Widget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageMapV1Widget> createState() => _ChatMessageMapV1WidgetState();
}

class _ChatMessageMapV1WidgetState extends State<ChatMessageMapV1Widget> {
  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void didUpdateWidget(covariant ChatMessageMapV1Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
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
        category: 'image',
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
        lat: widget.message.data['lat'],
        lon: widget.message.data['lon'],
        zoom: double.parse(widget.message.data['zoom'].toString()),
        image: widget.message.data['url'],
      ),
    );
  }

  Widget child({
    required double lat,
    required double lon,
    required double zoom,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        // launch it
        final url = 'geo:$lat,$lon?z=$zoom';
        Services.launch.launch(url);
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
            if (image != null && !image.startsWith('http'))
              Positioned(
                top: -16,
                left: -16,
                right: -16,
                bottom: -16,
                child: Image.file(
                  File(image),
                  fit: BoxFit.cover,
                ),
              ),
            if (image != null && image.startsWith('http'))
              Positioned(
                top: -16,
                left: -16,
                right: -16,
                bottom: -16,
                child: CachedImageWidget(
                  url: image,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
