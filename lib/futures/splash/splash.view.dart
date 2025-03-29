import 'package:chat/futures/splash/splash.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Obx(
      () => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('lib/app/assets/images/splash_logo.png'),
            if (controller.deprecated.value == true)
              Positioned(
                left: 56,
                right: 56,
                bottom: MediaQuery.of(context).padding.bottom + 50,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'این نسخه منسوخ شده است لطفا جهت استفاده بروزرسانی کنید.',
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.6),
                      ),
                      const Gap(20),
                      OutlinedButton.icon(
                        onPressed: () {
                          controller.download();
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('دانلود نسخه جدید'),
                      ),
                    ]),
              ),
            if (controller.deprecated.value == false)
              Positioned(
                left: 20,
                right: 20,
                bottom: Get.mediaQuery.padding.bottom + 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // linner loading
                    const SizedBox(
                      width: 120,
                      child: LinearProgressIndicator(),
                    ),
                    const Gap(20),
                    Obx(
                      () => Text(
                        controller.status.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
