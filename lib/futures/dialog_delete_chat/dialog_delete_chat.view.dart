import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogDeleteChatView extends StatelessWidget {
  const DialogDeleteChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حذف چت',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(4),
            const Text(
              'آیا می خواهید چت خود را با این کاربر حذف کنید ؟',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(64, 46)),
                  ),
                  child: const Text('انصراف'),
                ),
                const Gap(4),
                ElevatedButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(64, 46)),
                  ),
                  child: Text(
                    'تایید و حذف',
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
