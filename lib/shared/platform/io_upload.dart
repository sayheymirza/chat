import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<dynamic> ChooseAFile({String access = '*/*', dynamic onPick}) async {
  List<String> formats = [];

  if (access.startsWith('video')) {
    formats = ['mp4'];
  }
  if (access.startsWith('audio')) {
    formats = ['mp3'];
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: formats,
    allowCompression: false,
  );

  if (result == null) {
    return null;
  }

  var file = result.files.first;

  return {
    'filename': file.name,
    'size': file.size,
    'blob': file.path,
  };
}

Future<dynamic> UploadAFile({required String url, required File file}) async {}
