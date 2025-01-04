import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogConfirmView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String cancel;
  final String submit;

  const DialogConfirmView({
    super.key,
    required this.title,
    required this.subtitle,
    this.cancel = 'انصراف',
    this.submit = 'تایید',
  });

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
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              subtitle,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(cancel),
                ),
                const Gap(4),
                ElevatedButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  child: Text(
                    submit,
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
