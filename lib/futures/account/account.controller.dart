import 'dart:io';

import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/vibration.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');

  RxInt avatarUploadPercent = 0.obs;
  RxBool avatarDisabled = false.obs;

  Future<void> onRefresh() async {
    try {
      await profile.fetchMyProfile();
      vibrate();
    } catch (e) {
      //
    }
  }

  Future<void> changeAvatar(String path) async {
    File file = File(path);

    avatarDisabled.value = true;

    var result = await ApiService.user.changeAvatar(
      file: file,
      callback: (percent) {
        avatarUploadPercent.value = percent;
      },
    );
    avatarDisabled.value = false;

    if (result.success) {
      avatarUploadPercent.value = 0;
      profile.profile.value.avatar = result.url!;
      profile.profile.value.defaultAvatar = false;
      showSnackbar(message: 'تصویر پروفایل شما تغییر کرد');
    } else {
      avatarUploadPercent.value = 0;
      showSnackbar(message: 'خطا در تغییر تصویر پروفایل رخ داد');
    }
  }

  Future<void> deleteAvatar() async {
    avatarDisabled.value = true;
    var result = await ApiService.user.deleteAvatar();
    avatarDisabled.value = false;

    if (result) {
      showSnackbar(message: 'تصویر پروفایل حذف شد');
      await profile.fetchMyProfile();
    } else {
      showSnackbar(message: 'خطا در حذف تصویر پروفایل رخ داد');
    }
  }
}
