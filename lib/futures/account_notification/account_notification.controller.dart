import 'dart:async';

import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/vibration.dart';
import 'package:get/get.dart';

class AccountNotificationController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');
  RxBool soundChat = false.obs;
  RxBool soundCall = false.obs;
  RxBool vibration = false.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    soundChat.value = (Services.configs
                .get<bool>(key: CONSTANTS.STORAGE_SETTINGS_SOUND_CHAT) ??
            true) !=
        false;
    soundCall.value = (Services.configs
                .get<bool>(key: CONSTANTS.STORAGE_SETTINGS_SOUND_CALL) ??
            true) !=
        false;
    vibration.value = (Services.configs
                .get<bool>(key: CONSTANTS.STORAGE_SETTINGS_VIBRATION) ??
            true) !=
        false;

    update();
  }

  void toggleSoundChat(bool value) {
    Services.configs.set(
      key: CONSTANTS.STORAGE_SETTINGS_SOUND_CHAT,
      value: value,
    );
    soundChat.value = value;
    vibrate();
  }

  void toggleSoundCall(bool value) {
    Services.configs.set(
      key: CONSTANTS.STORAGE_SETTINGS_SOUND_CALL,
      value: value,
    );
    soundCall.value = value;
    vibrate();
  }

  void toggleVibration(bool value) {
    Services.configs.set(
      key: CONSTANTS.STORAGE_SETTINGS_VIBRATION,
      value: value,
    );
    vibration.value = value;
    vibrate();
  }

  void submit() {
    if (timer != null) {
      timer!.cancel();
    }

    profile.profile.value = profile.profile.value.copyWith({});

    timer = Timer(const Duration(seconds: 1), () {
      Services.profile.changeSettings().then((_) {
        vibrate();
      });
    });
  }
}
