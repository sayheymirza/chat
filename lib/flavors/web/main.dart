import 'dart:developer';

import 'package:chat/flavors/web/service.dart';
import 'package:chat/run.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web; // Add

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  log('[flavors/web/main.dart] web flavor is listening');
  FlavorWeb().listen();

  CONSTANTS.FLAVOR = "web";

  CONSTANTS.PAYMENT_CALLBACK =
      "${web.window.location.protocol}//${web.window.location.host}/#/payment";
  run();
}
