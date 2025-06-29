import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PurchaseSupportCardWidget extends StatelessWidget {
  const PurchaseSupportCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade400,
            Colors.red.shade400,
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'چنانچه در هر یک از مراحل پرداخت با مشکلی برخوردید؛ جهت رفع مشکل، مورد را از طریق فرم موجود در لینک روبرو به پشتیبانی فنی اطلاع دهید. ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const Gap(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Get.toNamed('/page/contact', arguments: 'webable');
                NavigationToNamed('/page/contact');
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Text('ارتباط با پشتیبانی'),
            ),
          ),
        ],
      ),
    );
  }
}
