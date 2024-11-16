import 'dart:io';

import 'package:chat/futures/cropper/cropper.controller.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CropperView extends GetView<CropperController> {
  const CropperView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CropperController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.paddingOf(context).bottom + 100,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          children: [
            // rotate 90 degrees to left
            IconButton(
              onPressed: () {
                controller.cropController.rotateLeft();
              },
              icon: const Icon(
                Icons.rotate_left,
                color: Colors.white,
              ),
            ),
            // rotate 90 degrees to right
            IconButton(
              onPressed: () {
                controller.cropController.rotateRight();
              },
              icon: const Icon(
                Icons.rotate_right,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Obx(
              () => ElevatedButton(
                onPressed: controller.cropping.value
                    ? null
                    : () {
                        controller.submit();
                      },
                child: controller.cropping.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'تایید و ادامه',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: CropImage(
          controller: controller.cropController,
          image: Image.file(
            File(Get.arguments['path']),
          ),
        ),
      ),
    );
  }
}
