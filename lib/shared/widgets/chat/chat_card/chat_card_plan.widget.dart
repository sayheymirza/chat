import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatCardPlanWidget extends StatelessWidget {
  final String userId;

  const ChatCardPlanWidget({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xffFF4B2B), Color(0xffFF416C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'برای ارسال پیام خصوصی و استفاده از چت صوتی و تصویری باید حداقل یکی از طرفین حساب کاربری ویژه داشته باشد. می توانید جهت خرید از این لینک استفاده کنید',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/app/purchase/one-step');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خرید حساب کاربری ویژه',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10),
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.deepPurpleAccent,
                  ),
                ],
              ),
            ),
          ),
          Gap(12),
          const Text(
            ' البته می توانید به کاربر پیام علاقه مندی به صورت رایگان بفرستید در صورتی که ایشان عضویت ویژه داشته باشند می توانید به گفتگو ادامه دهید',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  '/app/default-message',
                  arguments: {
                    'id': userId,
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ارسال پیام علاقه مندی (رایگان)',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10),
                  Icon(
                    Icons.message,
                    color: Colors.deepPurpleAccent,
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
