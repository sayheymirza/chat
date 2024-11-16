import 'dart:io';

import 'package:chat/futures/dialog_image/dialog_image.view.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessageImageV1Widget extends StatelessWidget {
  final String url;

  const ChatMessageImageV1Widget({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
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
