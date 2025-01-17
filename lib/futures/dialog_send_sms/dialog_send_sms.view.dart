import 'package:chat/futures/dialog_send_sms/dialog_send_sms.controller.dart';
import 'package:chat/shared/widgets/or.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogSendSMSView extends GetView<DialogSendSMSController> {
  final String userId;

  const DialogSendSMSView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(DialogSendSMSController());

    return Obx(
      () => Container(
        height: Get.mediaQuery.padding.bottom + 500,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: Get.mediaQuery.padding.bottom + 16,
        ),
        width: Get.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Icon(
              Icons.sms,
              color: Colors.green.shade500,
              size: 96,
            ),
            const Gap(12),
            Text(
              'ارسال پیام دعوت به گفتگو',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(4),
            Text(
              'اعتبار باقی مانده : ${controller.profile.profile.value.plan!.sms ?? 0}',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.disabled.value
                    ? null
                    : () {
                        controller.submit(userId: userId);
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
                    : Text(
                        'ارسال پیامک',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const Gap(20),
            const OrWidget(),
            const Gap(8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: controller.disabled.value
                    ? null
                    : () {
                        Get.toNamed('/app/purchase/one-step');
                      },
                child: Text('خرید اعتبار پیامکی'),
              ),
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
