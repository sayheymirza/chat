import 'dart:developer';

import 'package:chat/flavors/direct/service.dart';
import 'package:chat/run.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  log('[flavors/direct/main.dart] put flavor Get service');

  Get.lazyPut(() => FlavorDirectService(), tag: 'flavor');

  run();
}
