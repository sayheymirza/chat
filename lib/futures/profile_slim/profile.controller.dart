import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class ProfileSlimController extends GetxController {
  RxBool loading = true.obs;
  Rx<ProfileModel> profile = ProfileModel().obs;

  @override
  void onInit() {
    super.onInit();

    load();
  }

  Future<void> load() async {
    var id = Get.parameters['id']!;

    if (id == 'me') {
      var result = await ApiService.user.me();

      if (result != null) {
        profile.value = result;
        loading.value = false;
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
        loading.value = false;
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
