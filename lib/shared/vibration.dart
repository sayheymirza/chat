import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:vibration/vibration.dart';

Future<void> vibrate() {
  if (Services.configs.get<bool>(key: CONSTANTS.STORAGE_SETTINGS_VIBRATION) ==
      false) return Future.value();

  return Vibration.vibrate(duration: 100);
}
