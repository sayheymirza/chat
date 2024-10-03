import 'dart:developer';

import 'package:chat/flavors/direct/service.dart';
import 'package:chat/run.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  log('[flavors/direct/main.dart] direct flavor is listening');
  FlavorDirect().listen();

  CONSTANTS.FLAVOR = "direct";

  run();
}
