import 'package:chat/futures/dialog_logout/dialog_logout.controller.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogLogoutView extends GetView<DialogLogoutController> {
  const DialogLogoutView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DialogLogoutController());

    return Obx(
      () => PopScope(
        canPop: !controller.disabled.value,
        child: Container(
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
                  'خروج از حساب کاربری',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                const Text(
                  'آیا مطمئین هستید که می خواهید از حساب کاربری خود خارج شوید؟',
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: controller.disabled.value
                          ? null
                          : () {
                              Get.back(canPop: !controller.disabled.value);
                              NavigationBack();
                            },
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(Size(64, 46)),
                      ),
                      child: const Text('انصراف'),
                    ),
                    const Gap(4),
                    ElevatedButton(
                      onPressed: controller.disabled.value
                          ? null
                          : () {
                              controller.submit();
                            },
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(Size(64, 46)),
                      ),
                      child: controller.disabled.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Get.theme.colorScheme.onPrimary,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
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
        ),
      ),
    );
  }
}
