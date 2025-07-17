import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class AccountDeleteLeaveController extends GetxController {
  RxBool disabled = false.obs;
  String description = '';
  RxMap<String, dynamic> texts = {
    'title': '',
    'placeholder': '',
    'button': '',
    'info_title': '',
    'info_text': '',
    'info_color': Colors.grey.shade100,
    'height': 250,
  }.obs;

  @override
  void onInit() {
    super.onInit();

    var type = Get.parameters['type'];

    if (type == 'delete') {
      texts.value = {
        'placeholder': 'علت حذف پروفایل خود را بنویسید',
        'button': 'تایید و حذف',
        'info_title': 'توضیحاتی در مورد حذف پروفایل:',
        'info_text':
            'در صورتی که پروفایل خود را حذف نمایید، پروفایل و پیام های ارسالی شما برای همیشه حذف خواهد شد و امکان بازگشت اطلاعات شما مقدور نیست\nدر ضمن امکان ثبت نام مجدد با این شماره موبایل امکان پذیر نخواهد بود',
        'info_color': Colors.red.shade100,
        'gradient_from': Colors.red.shade500,
        'gradient_to': Colors.red.shade700,
        'height': 250,
      } as Map<String, dynamic>;
    }
    if (type == 'leave') {
      texts.value = {
        'placeholder': 'علت انصراف خود را بنویسید',
        'button': 'تایید و انصراف',
        'info_title': 'توضیحاتی در مورد انصراف از عضویت:',
        'info_text':
            'در صورتی که از عضویت خود انصراف دهید، پروفایل و پیام های ارسالی شما برای هیچ یک از کاربران قابل مشاهده نخواهد بود.\nچنانچه پس از انصراف اقدام به ورود به پروفایلتان نمایید، پروفایل شما مجددا به صورت خودکار فعال می گردد.\nمنتظر بازگشت مجدد شما بزودی هستیم.',
        'info_color': Colors.yellow.shade100,
        'gradient_from': Colors.orange.shade500,
        'gradient_to': Colors.orange.shade700,
        'height': 290,
      } as Map<String, dynamic>;
    }
  }

  Future<void> submit() async {
    // if message is empty
    if (description.isEmpty) {
      showSnackbar(message: 'لطفا دلیل خود را وارد کنید');
      return;
    }

    // if message length less than 5
    if (description.length < 5) {
      showSnackbar(message: 'لطفا دلیل خود را به طور کامل وارد کنید');
      return;
    }

    // submit request

    try {
      disabled.value = true;

      var result = await ApiService.user.disable(
        type: Get.parameters['type']!,
        description: description,
      );

      if (result) {
        // logout
        await Services.app.logout();

        Restart.restartApp();
      } else {
        showSnackbar(message: 'خطایی رخ داد');
      }

      disabled.value = false;
    } catch (e) {
      disabled.value = false;
      showSnackbar(message: 'خطایی نامشخص رخ داد');
    }
  }
}
