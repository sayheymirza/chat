import 'dart:html' as html;
import 'dart:typed_data'; // فقط برای وب

Future<String> getFilePath(Uint8List compressedBytes, String ext) async {
  // در وب: blob URL بساز
  final blob = html.Blob([compressedBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  return url;
}
