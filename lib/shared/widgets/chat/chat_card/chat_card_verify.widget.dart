import 'package:chat/futures/dialog_change_phone/dialog_change_phone.view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatCardVerifyWidget extends StatelessWidget {
  final Function onChange;

  const ChatCardVerifyWidget({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xffFF4B2B), Color(0xffFF416C)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'جهت ارسال پیامک دعوت به گفتگو یا ارسال پیام خصوصی و استفاده از چت و تماس صوتی و تصویری نیاز به تایید شماره موبایل شما هست در صورتیکه قصد دارید شماره موبایل خود را عوض کنید روی دکمه زیر کلیک کنید',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(DialogChangePhoneView()).then((_) => onChange());
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'تغییر شماره موبایل',
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10),
                  Icon(
                    Icons.phone_iphone,
                    color: Get.theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Gap(12),
          const Text(
            'در صورت تمایل برای تایید موبایل با شماره تلفن روی دکمه زیر کلیک کنید',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/app/account_verify_phone')!
                    .then((_) => onChange());
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'تایید شماره موبایل',
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10),
                  Icon(
                    Icons.phone_iphone,
                    color: Get.theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
