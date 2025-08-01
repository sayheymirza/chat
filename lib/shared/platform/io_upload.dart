import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<dynamic> ChooseAFile({String access = '*/*', dynamic onPick}) async {
  List<String> formats = [];

  if (access.startsWith('video')) {
    formats = ['mp4', 'mkv', 'avi', 'mov', 'webm'];
  }
  if (access.startsWith('audio')) {
    formats = ['mp3', 'wav', 'ogg', 'flac', 'aac'];
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: formats,
    allowCompression: false,
  );

  if (result == null) {
    if (onPick != null) {
      onPick(null);
    }

    return null;
  }

  var file = result.files.first;

  var data = {
    'filename': file.name,
    'size': file.size,
    'blob': file.path,
  };

  if (onPick != null) {
    onPick(jsonEncode(data));
  }

  return data;
}

Future<dynamic> UploadAFile({required String url, required File file}) async {}
