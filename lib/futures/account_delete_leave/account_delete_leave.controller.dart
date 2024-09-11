import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  }.obs;

  @override
  void onInit() {
    super.onInit();

    var type = Get.parameters['type'];

    if (type == 'delete') {
      texts.value = {
        'title': 'حذف حساب کاربری',
        'placeholder': 'علت حذف حساب کاربری را وارد کنید',
        'button': 'تایید و حذف حساب کاربری',
        'info_title': 'توضیحاتی در مورد حذف پروفایل:',
        'info_text':
            'در صورتی که پروفایل خود را حذف نمایید، پروفایل و پیام های ارسالی شما برای همیشه حذف خواهد شد و امکان بازگشت اطلاعات شما مقدور نیست\nدر ضمن امکان ثبت نام مجدد با این شماره موبایل امکان پذیر نخواهد بود',
        'info_color': Colors.red.shade100,
      } as Map<String, dynamic>;
    }
    if (type == 'leave') {
      texts.value = {
        'title': 'غیر فعال سازی حساب کاربری',
        'placeholder': 'علت غیر فعال سازی حساب کاربری را وارد کنید',
        'button': 'تایید غیر فعال سازی حساب کاربری',
        'info_title': 'توضیحاتی در مورد غیر فعال سازی حساب کاربری:',
        'info_text':
            'در صورتی که از عضویت خود انصراف دهید، پروفایل و پیام های ارسالی شما برای هیچ یک از کاربران قابل مشاهده نخواهد بود.\nچنانچه پس از انصراف اقدام به ورود به پروفایلتان نمایید، پروفایل شما مجددا به صورت خودکار فعال می گردد.\nمنتظر بازگشت مجدد شما بزودی هستیم',
        'info_color': Colors.yellow.shade100,
      } as Map<String, dynamic>;
    }
  }

  Future<void> submit() async {
    // if message is empty
    if (description.isEmpty) {
      showSnackbar(message: 'لطفا دلیل خود را وارد کنید');
      return;
    }

    // if message length less than 10
    if (description.length < 10) {
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
        // clear the storage
        await Services.configs.unset(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

        Get.offAllNamed('/');
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
