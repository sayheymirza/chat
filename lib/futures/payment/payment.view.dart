import 'package:chat/futures/payment/payment.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        controller.home();
      },
      child: Scaffold(
          body: {
        'loading': loading(),
        'ok': result(
          icon: Icons.done_rounded,
          color: Colors.green,
          text: 'پرداخت شما موفق بود',
        ),
        'nok': result(
          icon: Icons.close_rounded,
          color: Colors.red,
          text: 'پرداخت شما ناموفق بود',
        ),
      }[controller.status.value]),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget result({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 128,
              color: color,
            ),
            const Gap(20),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Positioned(
          left: 50,
          right: 50,
          bottom: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              controller.home();
            },
            label: const Text('بازگشت'),
          ),
        ),
      ],
    );
  }
}
