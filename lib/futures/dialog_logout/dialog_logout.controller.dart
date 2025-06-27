import 'dart:async';

import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class DialogLogoutController extends GetxController {
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

  Future<void> submit() async {
    try {
      disabled.value = true;

      await Services.app.logout();

      disabled.value = false;

      if (GetPlatform.isWeb) {
        Get.offAllNamed('/');
      } else {
        Restart.restartApp();
      }
    } catch (e) {
      disabled.value = false;
      showSnackbar(message: 'خطا در هنگام خروج از حساب کاربری رخ داد');
      //
    }
  }
}
