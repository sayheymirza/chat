import 'package:flutter/material.dart';

class CardNumbersBlockedWidget extends StatelessWidget {
  const CardNumbersBlockedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'کاربر گرامی اگر رمز جدید و تاییدیه موبایل دریافت نمی‌کنید عدد ۱۲ را به این سر شماره پیامک کنید\n\n300059111112\n9830002659666661\n98100010007700',
      ),
    );
  }

}