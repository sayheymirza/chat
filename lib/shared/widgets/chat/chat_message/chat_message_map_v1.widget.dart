import 'dart:io';

import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:flutter/material.dart';

class ChatMessageMapV1Widget extends StatelessWidget {
  final double lat;
  final double lon;
  final double zoom;
  final String? image;

  const ChatMessageMapV1Widget({
    super.key,
    required this.lat,
    required this.lon,
    required this.zoom,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
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
            if (image != null && !image!.startsWith('http'))
              Positioned(
                top: -16,
                left: -16,
                right: -16,
                bottom: -16,
                child: Image.file(
                  File(image!),
                  fit: BoxFit.cover,
                ),
              ),
            if (image != null && image!.startsWith('http'))
              Positioned(
                top: -16,
                left: -16,
                right: -16,
                bottom: -16,
                child: CachedImageWidget(
                  url: image!,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
