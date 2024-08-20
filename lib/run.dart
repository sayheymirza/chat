import 'package:chat/app.dart';
import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/chrome.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void run() async {
  // shared services
  Services.put();

  // api services
  ApiService.put();

  // init get storage
  await GetStorage.init();

  Get.find<ChromeService>(tag: 'chrome').transparent();

  runApp(const App());
}
