import 'dart:ui';

import 'package:chat/shared/platform/io_cropper_file.dart'
    if (dart.html) 'package:chat/shared/web/web_cropper_file.dart' as platform;
import 'package:chat/shared/services.dart';
import 'package:crop_image/crop_image.dart';
import 'package:get/get.dart';

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

      String path = await platform.getFilePath(
        compressedBytes,
        Get.arguments['path'].split(".").last,
      );

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
