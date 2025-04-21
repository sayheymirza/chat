import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogBackView extends StatelessWidget {
  const DialogBackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 200,
      width: Get.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'خروج از اپلیکیشن',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            const Text(
              'آیا مطمئین هستید که می خواهید از اپلیکیشن خارج شوید؟',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
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
                    'تایید و خروج',
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            Gap(MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
