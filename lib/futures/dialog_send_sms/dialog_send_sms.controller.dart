import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class DialogSendSMSController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');
  RxBool disabled = false.obs;

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    if (subevents == null) {
      NavigationOpenedDialog();

      subevents = event.on<EventModel>().listen((data) async {
        if (data.event == EVENTS.NAVIGATION_BACK) {
          Get.back();
        }
      });
    }
  }

  @override
  void onReady() {
    super.onReady();

    Services.profile.fetchMyProfile();
  }

  Future<void> submit({required String userId}) async {
    try {
      disabled.value = true;
      var result = await ApiService.user.sendSMS(user: userId);
      disabled.value = false;

      if (result.status) {
        // update the user's profile
        await Services.profile.fetchMyProfile();

        Get.back();
      }

      showSnackbar(message: result.message);
    } catch (e) {
      disabled.value = false;
    }
  }
}
