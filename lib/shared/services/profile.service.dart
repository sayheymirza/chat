import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/user.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/vibration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileService extends GetxService {
  Rx<ProfileModel> profile = ProfileModel().obs;

  Future<bool> fetchMyProfile() async {
    try {
      var result = await ApiService.user.me();

      if (result == null) {
        log('[profile.service.dart] fetch my profile got null');
      } else {
        profile.value = result;
        log('[profile.service.dart] fetched my profile');
      }

      return true;
    } catch (e) {
      if (Get.currentRoute != '/500') {
        Get.offAllNamed('/500');
      }

      Get.dialog(
        Scaffold(
          body: Container(
            color: Colors.white,
            child: Text(e.toString()),
          ),
        ),
      );

      log('[profile.service.dart] fetch my profile got an error');

      Services.firebase.crash(e.toString());

      return false;
    }
  }

  Future<bool> changeSettings({Map<String, bool> values = const {}}) {
    var request = ApiUserChangeSettingsRequestModel(
      voiceCall:
          values['voiceCall'] ?? profile.value.permission?.voiceCall ?? false,
      videoCall:
          values['videoCall'] ?? profile.value.permission?.videoCall ?? false,
      notificationReaction: values['notificationReaction'] ??
          profile.value.permission?.notificationReaction ??
          false,
      notificationChat: values['notificationChat'] ??
          profile.value.permission?.notificationChat ??
          false,
      notificationVoiceCall: values['notificationVoiceCall'] ??
          profile.value.permission?.notificationVoiceCall ??
          false,
      notificationVideoCall: values['notificationVideoCall'] ??
          profile.value.permission?.notificationVideoCall ??
          false,
    );

    return ApiService.user.changeSettings(request).then((value) {
      if (value) {
        profile.value = profile.value.copyWith({
          "permissions": request.toJson(),
        });
        vibrate();
      }
      return value;
    });
  }
}
