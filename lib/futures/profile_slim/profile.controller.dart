import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileSlimController extends GetxController {
  RxBool loading = true.obs;
  Rx<ProfileModel> profile = ProfileModel().obs;

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    load();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.NAVIGATION_BACK) {
        onBack();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    subevents!.cancel();
  }

  void onBack() {
    if (kIsWeb) {
      print('on backkkk');

      Get.back();

      NavigationBack();
    }
  }

  void unloading() {
    Timer(Duration(milliseconds: 100), () {
      loading.value = false;
    });
  }

  Future<void> load() async {
    var id = Get.parameters['id']!;

    if (kIsWeb) {
      NavigationToNamed('/profile/$id');
    }

    if (id == 'me') {
      var result = await ApiService.user.me();

      if (result != null) {
        profile.value = result;
        unloading();
      } else {
        showSnackbar(message: 'خطا در دریافت پروفایل رخ داد');
      }
    } else {
      loadUser();
      fetch();
      Services.user.see(userId: id);
    }
  }

  Future<void> loadUser() async {
    try {
      var id = Get.parameters['id']!;
      var result = await Services.user.one(userId: id);

      if (result != null) {
        profile.value = result;
        unloading();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetch() async {
    var id = Get.parameters['id']!;

    await Services.user.fetch(userId: id);

    loadUser();
  }
}
