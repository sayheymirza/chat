import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class DialogFeedbackController extends GetxController {
  RxInt score = 0.obs;
  RxString message = ''.obs;
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
      if (score.value == 0) {
        showSnackbar(message: 'روی ستاره ها کلیک کنید');
        return;
      }

      disabled.value = true;

      var result = await ApiService.data.feedback(
        score: score.value,
        description: message.value,
      );

      disabled.value = false;

      if (result.status) {
        Get.back();
      }

      showSnackbar(message: result.message);
    } catch (e) {
      disabled.value = false;
    }
  }
}
