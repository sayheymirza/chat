import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAboutWelcomePlanWidget extends StatefulWidget {
  const CardAboutWelcomePlanWidget({super.key});

  @override
  State<CardAboutWelcomePlanWidget> createState() =>
      _CardAboutWelcomePlanWidgetState();
}

class _CardAboutWelcomePlanWidgetState
    extends State<CardAboutWelcomePlanWidget> {
  String time = 'کوتاهی';

  @override
  initState() {
    super.initState();

    var value = Services.configs.get(key: 'config:free-account-time');
    if (value != null) {
      time = value;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.yellow.shade600,
            Colors.amber.shade800,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'بسته خوش آمد گویی برای شما فعال است',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              'این بسته به مدت $time برای شما فعال است تا از تمامی قابلیت های برنامه به صورت رایگان استفاده کنید'),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed('/page/plans');
                  },
                  child: const Text(
                    'بیشتر بدانید',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/app/purchase/one-step');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.white,
                    ),
                  ),
                  child: const Text(
                    'خریداری بسته',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
