import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class DialogLogoutController extends GetxController {
  RxBool disabled = false.obs;

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
