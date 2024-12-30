import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class CallController extends GetxController {
  InAppWebViewController? web;

  RxBool microphone = true.obs;
  RxBool camera = true.obs;

  Future<void> microphoneToggle() async {
    microphone.value = !microphone.value;
  }

  Future<void> cameraToggle() async {
    camera.value = !camera.value;
  }

  Future<void> hangup() async {
    Get.back();
  }
}
