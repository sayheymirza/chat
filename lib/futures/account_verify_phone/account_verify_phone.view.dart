import 'package:chat/futures/account_verify_phone/account_verify_phone.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountVerifyPhoneView extends GetView<AccountVerifyPhoneController> {
  const AccountVerifyPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountVerifyPhoneController());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: footer(),
      body: container(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const Gap(20),
          const Text(
            'تایید شماره موبایل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          Text(
            'کد تایید ۶ رقمی به شماره ${controller.profile.profile.value.phone} پیامک شده را وارد کنید.',
          ),
          const Gap(32),
          TextFormField(
            enabled: !controller.disabled.value,
            controller: controller.codeController,
            decoration: const InputDecoration(
              label: Text('کد تایید'),
              hintText: '0000',
              hintTextDirection: TextDirection.ltr,
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.phone,
            maxLength: 4,
            onChanged: (String value) {
              controller.code.value = value;
            },
            onFieldSubmitted: (_) {
              controller.submit();
            },
          ),
        ],
      ),
    );
  }

  Widget footer() {
    return Obx(
      () => SizedBox(
        height: 120,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (controller.sent.value)
              SizedBox(
                width: Get.width - 32,
                child: ElevatedButton(
                  onPressed: controller.time.value != '00:00'
                      ? null
                      : () {
                          controller.requestOTP();
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      controller.time.value != '00:00'
                          ? Colors.transparent
                          : Get.theme.colorScheme.primaryContainer,
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                  ),
                  child: Text(
                    controller.time.value == '00:00'
                        ? 'ارسال مجدد کد تایید'
                        : '${controller.time.value} مانده تا دریافت مجدد کد',
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            const Gap(10),
            SizedBox(
              width: Get.width - 32,
              child: ElevatedButton(
                onPressed: controller.disabled.value
                    ? null
                    : () {
                        controller.submit();
                      },
                child: controller.disabled.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Get.theme.colorScheme.onPrimary,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'تایید',
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

  Widget container({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      margin: EdgeInsets.only(top: Get.mediaQuery.padding.top + 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
