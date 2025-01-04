import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

class DialogImageView extends StatefulWidget {
  final String url;
  final bool downloadable;

  const DialogImageView({
    super.key,
    required this.url,
    this.downloadable = false,
  });

  @override
  State<DialogImageView> createState() => _DialogImageViewState();
}

class _DialogImageViewState extends State<DialogImageView> {
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.12),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CachedImageWidget(
                url: widget.url,
                background: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: Get.mediaQuery.padding.top + 16,
            right: 16,
            child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close_rounded, color: Colors.black,)),
          ),
          if (widget.downloadable)
            Positioned(
              bottom: Get.mediaQuery.padding.bottom + 32,
              child: GestureDetector(
                onTap: () {
                  if (downloading) return;
                  downloading = true;
                  setState(() {});
                  Services.file
                      .download(
                    url: widget.url,
                    category: 'image',
                  )
                      .then((_) {
                    downloading = false;
                    setState(() {});
                    showSnackbar(message: 'دانلود شد');
                  }).catchError((_) {
                    downloading = false;
                    setState(() {});
                    showSnackbar(message: 'خطایی در دانلود رخ داد');
                  });
                },
                child: SizedBox(
                  width: 72,
                  height: 92,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !downloading
                          ? Icon(Icons.download_rounded)
                          : SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            ),
                      const Gap(12),
                      Text(
                        'دانلود',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ).asGlass();
  }
}
