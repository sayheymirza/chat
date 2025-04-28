import 'dart:html' as html; // فقط برای وب
import 'dart:io' as io;
import 'dart:ui';

import 'package:chat/shared/services.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CropperController extends GetxController {
  CropController cropController = CropController(
    /// If not specified, [aspectRatio] will not be enforced.
    aspectRatio: 1,

    /// Specify in percentages (1 means full width and height). Defaults to the full image.
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  RxBool cropping = false.obs;

  @override
  void onClose() {
    super.onClose();

    Services.chrome.transparent();
  }

  Future<void> submit() async {
    if (cropping.value) return;

    try {
      cropping.value = true;

      var bitmap = await cropController.croppedBitmap(
        quality: FilterQuality.low,
      );

      var data = await bitmap.toByteData(format: ImageByteFormat.png);
      var bytes = data!.buffer.asUint8List();

      var compressedBytes = await Services.compress.image(bytes: bytes);

      String path;

      if (kIsWeb) {
        // در وب: blob URL بساز
        final blob = html.Blob([compressedBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        path = url; // مسیر برابر با blob URL
      } else {
        // در موبایل/دسکتاپ: فایل واقعی بساز
        final tempDir = await getTemporaryDirectory();

        path =
            "${tempDir.path}/cropped.${DateTime.now().millisecondsSinceEpoch}.${Get.arguments['path'].split(".").last}";

        final file = io.File(path);
        await file.writeAsBytes(compressedBytes);
      }

      Get.back(
        result: path, // همیشه یک string میدی
      );
    } catch (e) {
      print(e);
    } finally {
      cropping.value = false;
    }
  }
}
