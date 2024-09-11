import 'package:chat/futures/account_delete_leave/account_delete_leave.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountDeleteLeaveView extends GetView<AccountDeleteLeaveController> {
  const AccountDeleteLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountDeleteLeaveController());

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            controller.texts['title']!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: Container(
          width: Get.width - 32,
          margin: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: controller.disabled.value
                ? null
                : () {
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
                : Text(
                    controller.texts['button']!,
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // textarea for message
              TextField(
                maxLines: 3,
                enabled: !controller.disabled.value,
                decoration: InputDecoration(
                  hintText: controller.texts['placeholder'],
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.description = value;
                },
                onSubmitted: (value) {
                  controller.description = value;
                  controller.disabled.value = false;
                },
              ),
              const Gap(16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: controller.texts['info_color']!,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.texts['info_title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      controller.texts['info_text']!,
                    ),
                  ],
                ),
              ),
              Gap(Get.bottomBarHeight + 32 + 16),
            ],
          ),
        ),
      ),
    );
  }
}
