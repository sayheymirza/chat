import 'dart:convert';
import 'dart:io';
import 'dart:js';
import 'dart:html' as html;

// ignore: unused_import
import 'package:mime/mime.dart' as mime;

import 'package:file_picker/file_picker.dart';
import 'package:js/js_util.dart';

Future<dynamic> ChooseAFile({String access = '*/*', dynamic onPick}) async {
  // return callMethod(context['window'], 'ChooseAFile', [
  //   access,
  //   allowInterop(
  //     (data) {
  //       print(data);
  //       if (onPick != null) {
  //         onPick(data);
  //       }
  //     },
  //   ),
  // ]);

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
    if (onPick != null) {
      onPick(null);
    }

    return null;
  }

  var file = result.files.first;

  // convert file to blob url like: 'blob:http://localhost:1234/abcdef'
  var blob = html.Blob(
    [file.bytes],
  );
  var url = html.Url.createObjectUrl(blob);

  var data = {
    'filename': file.name,
    'size': file.size,
    'blob': url,
  };

  if (onPick != null) {
    onPick(jsonEncode(data));
  }

  return data;
}

Future<dynamic> UploadAFile({required String url, required File file}) async {
  return callMethod(context['window'], 'UploadAFile', [
    url,
    file,
    (dynamic data) {
      print(data);
    }
  ]);
}
