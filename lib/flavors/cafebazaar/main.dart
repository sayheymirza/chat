import 'dart:developer';

import 'package:chat/flavors/cafebazaar/service.dart';
import 'package:chat/run.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  log('[flavors/cafebazaar/main.dart] direct flavor is listening');
  FlavorCafebazaar().listen();

  CONSTANTS.FLAVOR = "cafebazaar";
  CONSTANTS.CAFEBAZAAR_RSA = "MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwCxKwxm1op6dTMd94SWKqMByQQXvDdOKQ7erCehcvhR/LynOSBhZ1EJrDZI35LysKqP/BEyWlxZc4BWk3VSrHzEHpDXmCxo8ZoVxPa9XnrXKSSV1QWGGzQEQUYYLdLmZmz1IohWKklZZ1D1jB2gp9LnN1mcX1zo0mrg87sZMhdG4jeRI8yyjYjtklLguiaAV0jtZGoKdKSpwsg0jZmqR5dwr6cC5p43JBDFBLoS4gECAwEAAQ==";

  run();
}
