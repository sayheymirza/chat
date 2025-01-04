import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressService extends GetxService {
  Future<Uint8List> image({
    required Uint8List bytes,
    int minWidth = 600,
    minHeight = 600,
  }) async {
    try {
      var result = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: 94,
        format: CompressFormat.png,
      );

      if (result != null) {
        // convert List<int> to File
        bytes = result;
      }

      return bytes;
    } catch (e) {
      return bytes;
    }
  }
}
