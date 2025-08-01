import 'package:chat/futures/account_delete_leave/account_delete_leave.controller.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/foundation.dart';
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: double.parse(controller.texts['height'].toString()),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.texts['gradient_from']!,
                      controller.texts['gradient_to']!,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Gap(Get.mediaQuery.padding.top),
                    //   back button
                    IconButton(
                      onPressed: () {
                        if (kIsWeb) {
                          Get.back();
                        } else {
                          NavigationBack();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const Gap(16),
                    Text(
                      controller.texts['info_title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      controller.texts['info_text']!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // textarea for message
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  maxLines: 3,
                  enabled: !controller.disabled.value,
                  decoration: InputDecoration(
                      hintText: controller.texts['placeholder'],
                      border: const OutlineInputBorder(),
                      helperText: "حداقل 5 حرف بنویسید"),
                  onChanged: (value) {
                    controller.description = value;
                  },
                  onSubmitted: (value) {
                    controller.description = value;
                    controller.disabled.value = false;
                  },
                ),
              ),
              Container(
                width: Get.width - 32,
                margin: EdgeInsets.only(
                  bottom: 10,
                  top: Get.mediaQuery.size.height -
                      controller.texts['height'] -
                      navigationBarHeight -
                      200,
                ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
