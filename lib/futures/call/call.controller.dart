import 'dart:async';

import 'package:chat/models/call.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';

class CallController extends GetxController {
  // livekit
  Room room = Room();

  RxBool microphone = true.obs;
  RxBool camera = true.obs;

  Rx<ProfileModel> profile = ProfileModel().obs;
  RxBool profiling = true.obs;

  RxString time = 'در حال برقرای ارتباط'.obs;

  Timer? timer;
  DateTime dateTime = DateTime(200, 1, 1, 0, 0, 0);

  @override
  void onInit() {
    super.onInit();

    askPermissions();

    // listen to room events (when remote participant added)
    room.events.on((event) {
      if (event is RoomEvent) {
        if (event is ParticipantConnectedEvent) {
          Services.sound.stop(type: 'dialing');
          durationing();
        }
      }
      // if i connected to room and room is not empty
      if (event is RoomConnectedEvent) {
        if (room.remoteParticipants.isNotEmpty) {
          Services.sound.stop(type: 'dialing');
          durationing();
        }
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();

    Services.configs.set(key: CONSTANTS.CALL_INCALL, value: Get.arguments);

    var userId = Get.arguments['userId'];

    if (userId != null) {
      var user = await Services.user.one(userId: userId);

      if (user != null) {
        profile.value = user;
      }
    }

    await askPermissions();

    start();
  }

  @override
  void onClose() async {
    super.onClose();

    await room.dispose();

    Services.configs.unset(key: CONSTANTS.CALL_INCALL);

    if (timer != null) {
      timer!.cancel();
    }
  }

  void start() {
    var url = Services.configs.get(key: CONSTANTS.STORAGE_LIVEKIT_URL);
    var token = Get.parameters['token'] ?? Get.arguments?['token'];

    var mode = Get.parameters['mode'] ?? Get.arguments?['mode'] ?? 'video';

    if (mode == "audio") {
      microphone.value = true;
      camera.value = false;
    } else {
      microphone.value = true;
      camera.value = true;
    }

    connect(
      url: url,
      token: token,
    );
  }

  Future<void> connect({
    required String url,
    required String token,
  }) async {
    print('[call.controller.dart] connecting ...');

    try {
      await room.connect(url, token);
      print('[call.controller.dart] connect success');
    } catch (e) {
      print('[call.controller.dart] connect error: $e');
      return;
    }

    // check microphone
    try {
      if (microphone.value) {
        await room.localParticipant!.setMicrophoneEnabled(true);
        print('[call.controller.dart] microphone enabled');
      } else {
        await room.localParticipant!.setMicrophoneEnabled(false);
        print('[call.controller.dart] microphone disabled');
      }
    } catch (e) {
      print('[call.controller.dart] microphone error: $e');
    }

    try {
      // check camera
      if (camera.value) {
        await room.localParticipant!.setCameraEnabled(true);
        print('[call.controller.dart] camera enabled');
      } else {
        await room.localParticipant!.setCameraEnabled(false);
        print('[call.controller.dart] camera disabled');
      }
    } catch (e) {
      print('[call.controller.dart] camera error: $e');
    }

    // update Getx Obx (when room updated)
    profiling.value = !camera.value;
    update();
  }

  void durationing() async {
    if (timer != null) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      dateTime = dateTime.add(const Duration(seconds: 1));

      var second = dateTime.second.toString();
      var minute = dateTime.minute.toString();

      second = second.length == 1 ? '0$second' : second;
      minute = minute.length == 1 ? '0$minute' : minute;

      time.value = '$minute:$second';
    });
  }

  Future<void> askPermissions() async {
    // checking user has permissions to mic and camera
    if (await Services.permission.has('mic') == false) {
      await Services.permission.ask('mic');
      askPermissions();
    }

    if (await Services.permission.has('camera') == false) {
      await Services.permission.ask('camera');
      askPermissions();
    }
  }

  Future<void> microphoneToggle() async {
    microphone.value = !microphone.value;

    try {
      if (microphone.value) {
        await room.localParticipant!.setMicrophoneEnabled(true);
        print('[call.controller.dart] microphone enabled');
      } else {
        await room.localParticipant!.setMicrophoneEnabled(false);
        print('[call.controller.dart] microphone disabled');
      }
    } catch (e) {
      print('[call.controller.dart] microphone error: $e');
    }
  }

  Future<void> cameraToggle() async {
    camera.value = !camera.value;

    try {
      // check camera
      if (camera.value) {
        await room.localParticipant!.setCameraEnabled(true);
        print('[call.controller.dart] camera enabled');
      } else {
        await room.localParticipant!.setCameraEnabled(false);
        print('[call.controller.dart] camera disabled');
      }
    } catch (e) {
      print('[call.controller.dart] camera error: $e');
    }

    // update Getx Obx (when room updated)
    profiling.value = !camera.value;
    update();
  }

  Future<void> hangup() async {
    Services.call.action(type: CALL_ACTIONS.END);
    Services.call.close();
  }
}
