import 'dart:io';
import 'dart:js';

import 'package:js/js_util.dart';

Future<dynamic> ChooseAFile({String access = '*/*', dynamic onPick}) async {
  return callMethod(context['window'], 'ChooseAFile', [
    access,
    allowInterop(
      (data) {
        if (onPick != null) {
          onPick(data);
        }
      },
    ),
  ]);
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
