import 'dart:io';

import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatefulWidget {
  final String url;
  final String category;
  final AlignmentGeometry alignment;
  final BoxFit? fit;

  const CachedImageWidget({
    super.key,
    required this.url,
    this.alignment = Alignment.center,
    this.fit,
    this.category = 'image',
  });

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  bool loading = false;
  bool errored = false;
  int downloading = 0;
  File? file;

  @override
  void initState() {
    super.initState();

    load(
      url: widget.url,
      category: widget.category,
    );
  }

  @override
  void didUpdateWidget(covariant CachedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    load(
      url: widget.url,
      category: widget.category,
    );
  }

  Future<void> load({
    required String url,
    required String category,
  }) async {
    try {
      loading = true;
      errored = false;
      setState(() {});

      var cache = await Services.cache.load(
        url: url,
        category: category,
        onPercent: (int percent) {
          downloading = percent;
        },
      );

      loading = false;

      if (cache != null) {
        file = cache;
        downloading = 100;
      } else {
        errored = true;
      }

      setState(() {});
    } catch (e) {
      loading = false;
      errored = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errored) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Center(
          child: Icon(
            Icons.image_rounded,
            color: Colors.grey.shade700,
          ),
        ),
      );
    }

    if (file != null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Image.file(
          file!,
          alignment: widget.alignment,
          fit: widget.fit,
        ),
      );
    }

    if (loading == true) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Center(
          child: CircularProgressIndicator(
            value: downloading == 0 ? null : downloading.toDouble(),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Center(
        child: Icon(
          Icons.image_rounded,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
