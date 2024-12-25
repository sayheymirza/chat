import 'dart:io';

import 'package:dio/dio.dart';

class DUModel {
  late int id;
  late String filename;
  late String category;
  late File? file;
  late int percent;
  late int total;
  late int sentOrRecived;
  late CancelToken cancelToken;
  late bool done;
  late String? url;
  late String? fileId;
  late Function? onDone;
  late Function? onProgress;
  late Function? onError;
  late dynamic meta;
  late bool cache;

  DUModel({
    required this.id,
    required this.category,
    required this.filename,
    required this.percent,
    required this.total,
    required this.sentOrRecived,
    required this.cancelToken,
    this.done = false,
    this.file,
    this.url,
    this.fileId,
    this.onDone,
    this.onProgress,
    this.onError,
    this.meta,
    this.cache = false,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'category': category,
      'percent': percent,
      'total': total,
      'sentOrRecived': sentOrRecived,
      'cancelToken': cancelToken,
      'done': done,
      'url': url,
      'fileId': fileId,
      'meta': meta,
      'cache': cache,
    };
  }
}
