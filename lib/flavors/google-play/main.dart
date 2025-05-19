import 'dart:developer';

import 'package:chat/flavors/google-play/service.dart';
import 'package:chat/run.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  log('[flavors/google-play/main.dart] google-play flavor is listening');
  FlavorGooglePlay().listen();

  CONSTANTS.FLAVOR = "google-play";
  CONSTANTS.PAYMENT_CALLBACK = "app://com.mahasal.app.mahasal/payment";

  run();
}
