import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class DialogFeedbackController extends GetxController {
  RxInt score = 0.obs;
  RxString message = ''.obs;
  RxBool disabled = false.obs;

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
