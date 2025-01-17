import 'dart:async';

import 'package:chat/models/call.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class CallController extends GetxController {
  InAppWebViewController? web;

  RxBool microphone = true.obs;
  RxBool camera = true.obs;
  RxString selected_camera = "default".obs;
  RxString selected_speaker = "default".obs;

  RxList<dynamic> devices = [].obs;

  Rx<ProfileModel> profile = ProfileModel().obs;
  RxBool profiling = true.obs;

  RxString time = 'در حال برقرای ارتباط'.obs;

  Timer? timer;
  DateTime dateTime = DateTime(200, 1, 1, 0, 0, 0);

  @override
  void onInit() {
    super.onInit();

    askPermissions();
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
  }

  @override
  void onClose() {
    super.onClose();

    Services.configs.unset(key: CONSTANTS.CALL_INCALL);

    if (timer != null) {
      timer!.cancel();
    }
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
  }

  Future<void> cameraToggle() async {
    camera.value = !camera.value;
  }

  Future<void> hangup() async {
    Services.call.action(type: CALL_ACTIONS.END);
    Services.call.close();
  }

  Future<void> openDevicesDialog() async {
    var _devices = [...devices.value];

    var result = await Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        child: ListView(
          children: [
            for (var device in _devices)
              ListTile(
                onTap: () {
                  Get.back(result: device);
                },
                leading: device['kind'] == 'audioinput'
                    ? Icon(Icons.speaker)
                    : Icon(Icons.camera_alt_rounded),
                title: Text(
                  device['label'].isEmpty ? 'Default' : device['label'],
                  style: TextStyle(
                    color: selected_camera.value == device['deviceId'] ||
                            selected_speaker.value == device['deviceId']
                        ? Get.theme.colorScheme.primary
                        : Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    print(result);

    if (result != null) {
      if (result['kind'] == 'audioinput') {
        selected_speaker.value = result['deviceId'];
      }

      if (result['kind'] == 'videoinput') {
        selected_camera.value = result['deviceId'];
      }
    }
  }
}
