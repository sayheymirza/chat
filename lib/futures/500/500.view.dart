import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Error500View extends StatefulWidget {
  const Error500View({super.key});

  @override
  State<Error500View> createState() => _Error500ViewState();
}

class _Error500ViewState extends State<Error500View> {
  int tries = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: Get.width - 32,
        child: OutlinedButton(
          onPressed: () async {
            if (tries >= 3) {
              showSnackbar(message: 'شما زیاد تلاش کردید');
              await Services.app.logout();
              Get.offAllNamed('/auth');
            } else {
              loading = true;
              setState(() {});
              Services.profile.fetchMyProfile().then((value) {
                loading = false;
                tries += 1;
                setState(() {});
                if (value) {
                  Get.toNamed('/app');
                } else {
                  showSnackbar(message: 'تلاش مجدد شکست خورد');
                }
              });
            }
          },
          child: const Text('تلاش مجدد'),
        ),
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mobiledata_off_rounded,
              size: 96,
            ),
            Gap(20),
            Text(
              'اتصال به سرور مشکل خورده است',
            ),
          ],
        ),
      ),
    );
  }
}
