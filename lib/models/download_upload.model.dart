import 'dart:io';

import 'package:dio/dio.dart';

class DUModel {
  late int id;
  late String filename;
  late String category;
  late File? file;
  late int percent;
  late int size;
  late CancelToken cancelToken;
  late bool done;
  late String? url;

  DUModel({
    required this.id,
    required this.category,
    required this.filename,
    required this.percent,
    required this.size,
    required this.cancelToken,
    this.done = false,
    this.file,
    this.url,
  });
}
