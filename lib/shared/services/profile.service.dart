import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileService extends GetxService {
  Rx<ProfileModel> profile = ProfileModel().obs;

  Future<void> fetchMyProfile() async {
    try {
      var result = await ApiService.user.me();

      if (result == null) {
        log('[profile.service.dart] fetch my profile got null');
      } else {
        profile.value = result;
        log('[profile.service.dart] fetched my profile');
      }
    } catch (e) {
      log('[profile.service.dart] fetch my profile got an error');
      debugPrint(e.toString());
    }
  }
}
