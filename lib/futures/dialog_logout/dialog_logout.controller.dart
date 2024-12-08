import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class DialogLogoutController extends GetxController {
  RxBool disabled = false.obs;

  Future<void> submit() async {
    try {
      disabled.value = true;

      await Services.app.logout();

      disabled.value = false;
      Get.offAllNamed('/');
      showSnackbar(message: 'شما از حساب کاربری خارج شدید');
    } catch (e) {
      disabled.value = false;
      showSnackbar(message: 'خطا در هنگام خروج از حساب کاربری رخ داد');
      //
    }
  }
}
