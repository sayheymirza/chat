import 'dart:io';

import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/apis/data.model.dart';
import 'package:chat/models/dropdown.model.dart';
import 'package:chat/models/home.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class ApiDataAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<List<DropdownModel>> dropdowns();

  Future<List<HomeComponentModel>> home();

  Future<ApiDataHandshakeResponseModel?> handshake();

  Future<ApiUploadResponseModel> upload({
    required File file,
    required Function({int percent, int total, int sent}) callback,
    CancelToken? cancelToken,
  });

  Future<ApiSimpleResponseModel> contact({
    required String reciver,
    required String title,
    required String description,
    String? email,
    String? file,
  });

  Future<ApiSimpleResponseModel> feedback({
    required int score,
    required String description,
  });
}
