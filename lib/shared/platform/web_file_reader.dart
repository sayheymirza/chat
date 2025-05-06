import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Uint8List> readFileBytes(dynamic file) async {
  final response = await html.HttpRequest.request(
    file.path,
    responseType: 'arraybuffer',
  );
  final byteBuffer = response.response;
  return byteBuffer.asUint8List();
}
