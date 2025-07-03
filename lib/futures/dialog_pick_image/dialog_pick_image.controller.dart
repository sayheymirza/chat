import 'dart:async';

import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DialogPickImageController extends GetxController {
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
  void onClose() {
    super.onClose();

    subevents!.cancel();
  }

  void image({
    required ImageSource source,
    bool editable = true,
  }) async {
    try {
      XFile? file = await ImagePicker().pickImage(
        source: source,
      );

      if (file != null) {
        var path = file.path;
        if (editable) {
          NavigationToNamed('/app/cropper', params: "path=${file.path}");
          // open cropper
          path = await Get.toNamed<dynamic>(
            "/app/cropper",
            arguments: {"path": file.path},
          );
        }

        NavigationPopDialog();

        // pop it
        Get.back(
          result: {
            "action": 'file',
            "data": path,
          },
        );
      }
    } catch (e) {
      //
    }
  }
}
