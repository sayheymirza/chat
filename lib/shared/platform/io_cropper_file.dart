import 'dart:io' as io;
import 'dart:typed_data'; // فقط برای وب

import 'package:path_provider/path_provider.dart';

Future<String> getFilePath(Uint8List compressedBytes, String ext) async {
  print("getFilePath on mobile");
  // در موبایل/دسکتاپ: فایل واقعی بساز
  final tempDir = await getTemporaryDirectory();

  var path =
      "${tempDir.path}/cropped.${DateTime.now().millisecondsSinceEpoch}.$ext";

  final file = io.File(path);
  await file.writeAsBytes(compressedBytes);

  return path;
}
