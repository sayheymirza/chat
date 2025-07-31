import 'dart:developer';
import 'package:chat/abstracts/controllers/player.controller.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class SoundService extends GetxService {
  PlayerController? beepController;
  PlayerController? dialingController;
  PlayerController? ringtoneController;

  void load() {
    Services.cache.put(
      url: Services.configs.get(key: CONSTANTS.AUDIO_BEEP_BEEP),
      category: 'audio',
    );
    Services.cache.put(
      url: Services.configs.get(key: CONSTANTS.AUDIO_DIALING),
      category: 'audio',
    );
    Services.cache.put(
      url: Services.configs.get(key: CONSTANTS.AUDIO_RINGTONE),
      category: 'audio',
    );
    Services.cache.put(
      url: Services.configs.get(key: CONSTANTS.AUDIO_MESSAGE),
      category: 'audio',
    );
  }

  void stop({required String type}) {
    log('[sound.service.dart] stop sound $type');

    if (type == "beep" || type == "beep-beep") {
      if (beepController != null) {
        beepController!.unload();
      }
    }

    if (type == "dialing") {
      if (dialingController != null) {
        dialingController!.unload();
      }
    }

    if (type == "ringtone") {
      if (ringtoneController != null) {
        ringtoneController!.unload();
      }
    }
  }

  void play({required String type}) async {
    if (type == "beep" || type == "beep-beep") {
      if (beepController != null) {
        beepController!.unload();
      }

      var url = Services.configs.get(key: CONSTANTS.AUDIO_BEEP_BEEP);
      if (url == null) return;
      beepController = PlayerController(onStateChange: () {});
      await beepController!.load(url: url);
      beepController!.controller!.setLooping(true);
      beepController!.play();
    }

    if (type == "dialing") {
      if (dialingController != null) {
        dialingController!.unload();
      }

      if (Services.configs
              .get<bool>(key: CONSTANTS.STORAGE_SETTINGS_SOUND_CALL) ==
          false) {
        return;
      }

      var url = Services.configs.get(key: CONSTANTS.AUDIO_DIALING);
      if (url == null) return;
      dialingController = PlayerController(onStateChange: () {});
      await dialingController!.load(url: url);
      dialingController!.controller!.setLooping(true);
      dialingController!.play();
    }

    if (type == "ringtone") {
      try {
        if (ringtoneController != null) {
          ringtoneController!.unload();
        }

        var url = Services.configs.get(key: CONSTANTS.AUDIO_RINGTONE);
        if (url == null) return;
        ringtoneController = PlayerController(onStateChange: () {});
        if (ringtoneController != null) {
          await ringtoneController!.load(url: url);
          ringtoneController!.controller!.setLooping(true);
          ringtoneController!.play();
        }
      } catch (e) {
        //
      }
    }

    if (type == "message") {
      var url = Services.configs.get(key: CONSTANTS.AUDIO_MESSAGE);
      if (url == null) return;
      var messageController = PlayerController(onStateChange: () {});
      await messageController.load(url: url);
      messageController.play();
    }
  }
}
