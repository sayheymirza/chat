import 'dart:html' as html;

import 'package:file_picker/file_picker.dart'; // فقط برای وب

Future<String> getFilePath(PlatformFile file) async {
  // در وب: blob URL بساز
  final blob = html.Blob([file.bytes!]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  return url;
}
