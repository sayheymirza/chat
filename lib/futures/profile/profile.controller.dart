import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profile = ProfileModel().obs;
  RxBool loading = true.obs;
  RxBool showOptions = false.obs;

  Future<void> load() async {
    var params = Get.arguments;

    var result = await (params['id'] == 0
        ? ApiService.user.me()
        : ApiService.user.one(
            id: params['id'],
          ));

    if (result != null) {
      profile.value = result;
      loading.value = false;
      showOptions.value = params['options'] != false;
    } else {
      Get.back();
      showSnackbar(message: 'خطا در دریافت پروفایل رخ داد');
    }
  }
}
