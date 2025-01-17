import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogConnectionView extends StatelessWidget {
  final String type;

  const DialogConnectionView({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    var title = '';
    var subtitle = '';
    var icon = Icons.error_rounded;

    switch (type) {
      case 'purchase':
      case 'payment':
        title = 'برای ادامه VPN خود را خاموش کنید';
        subtitle =
            'اگر VPN شما روشن می باشد آن را خاموش کنید تا مشکل پرداخت بر نخورید';
        break;
      case 'offline':
      default:
        title = 'عدم ارتباط با سرور';
        subtitle = 'ارتباط خود را اینترنت بررسی کنید و دوباره تلاش کنید';
    }

    return Container(
      height: 350,
      width: Get.width,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          const Gap(16),
          Icon(
            icon,
            color: Colors.red,
            size: 64,
          ),
          const Gap(24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(10),
          const Spacer(),
          SizedBox(
            width: Get.width - 64,
            child: OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('ادامه'),
            ),
          ),
          Gap(Get.mediaQuery.padding.bottom)
        ],
      ),
    );
  }
}
