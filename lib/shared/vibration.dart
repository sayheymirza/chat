import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

Future<void> vibrate({int duration = 100}) {
  if (kIsWeb) return Future.value();

  if (Services.configs
          .get(key: CONSTANTS.STORAGE_SETTINGS_VIBRATION)
          .toString() ==
      'false') {
    return Future.value();
  }

  return Vibration.vibrate(duration: duration);
}
