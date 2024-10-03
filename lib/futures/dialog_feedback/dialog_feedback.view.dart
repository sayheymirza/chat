import 'package:chat/futures/dialog_feedback/dialog_feedback.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogFeedbackView extends GetView<DialogFeedbackController> {
  const DialogFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DialogFeedbackController());

    return Container(
      width: double.infinity,
      height: Get.mediaQuery.padding.bottom + 400,
      padding: EdgeInsets.only(
        top: 32,
        left: 32,
        right: 32,
        bottom: Get.mediaQuery.padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "به ما امتیاز بدهید",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 42,
                  child: Text(
                    'عالی',
                    textAlign: TextAlign.center,
                  ),
                ),
                ...List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      if (controller.disabled.value) return;
                      controller.score.value = 5 - index;
                    },
                    child: Icon(
                      controller.score.value >= 5 - index
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.yellow.shade600,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 42,
                  child: Text(
                    'بد',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Gap(20),
            TextField(
              enabled: !controller.disabled.value,
              decoration: const InputDecoration(
                hintText: "نظر و پیشنهاداتان را بنویسید",
              ),
              minLines: 3,
              maxLines: 4,
              onChanged: (String value) {
                controller.message.value = value;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.submit();
                },
                child: controller.disabled.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "ارسال",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
