import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChromeService extends GetxService {
  static ChromeService get self => Get.find();

  void transparent({Brightness statusBarIconBrightness = Brightness.dark}) {
    log('[chrome.service.dart] using transparent chrome ui style');

    // status bar color and navigation bar to white color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Colors.white.withOpacity(0.01),
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarColor: Colors.white.withOpacity(0.01),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // overlay navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );

    // lock orientation to portraitUp
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
  }
}
