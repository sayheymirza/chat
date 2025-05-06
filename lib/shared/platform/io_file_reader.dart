import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> readFileBytes(dynamic file) async {
  if (file is File) {
    return await file.readAsBytes();
  }
  throw UnsupportedError('Unsupported file type on mobile');
}
