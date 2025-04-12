import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogSmsSendErrorView extends StatelessWidget {
  const DialogSmsSendErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 300,
      width: Get.width,
      padding: EdgeInsets.all(20),
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
          Text(
            Services.configs.get(
              key: CONSTANTS.STORAGE_VERIFY_PHONE_DESCRIPTION,
            ),
          ),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              child: Text('بستن'),
            ),
          ),
          Gap(MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
