import 'package:chat/futures/account_security/account_security.controller.dart';
import 'package:chat/futures/dialog_change_password/dialog_change_password.view.dart';
import 'package:chat/futures/dialog_change_phone/dialog_change_phone.view.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSecurityView extends GetView<AccountSecurityController> {
  const AccountSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountSecurityController());

    return Scaffold(
      appBar: const GradientAppBarWidget(
        back: true,
        title: "دسترسی و امنیت",
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  "تنظیمات دریافت تماس",
                ),
                dense: true,
              ),
              ListTile(
                onTap: () {
                  var value =
                      controller.profile.profile.value.permission?.voiceCall ??
                          false;

                  controller.profile.profile.value.permission!.voiceCall =
                      !value;
                  controller.submit();
                },
                leading: const Icon(Icons.call),
                title: const Text("دسترسی به تماس صوتی"),
                trailing: Switch(
                  value:
                      controller.profile.profile.value.permission?.voiceCall ??
                          false,
                  onChanged: (value) {
                    controller.profile.profile.value.permission!.voiceCall =
                        value;
                    controller.submit();
                  },
                ),
              ),
              // video call permission with switch
              ListTile(
                onTap: () {
                  var value =
                      controller.profile.profile.value.permission?.videoCall ??
                          false;

                  controller.profile.profile.value.permission!.videoCall =
                      !value;
                  controller.submit();
                },
                leading: const Icon(Icons.videocam),
                title: const Text("دسترسی به تماس تصویری"),
                trailing: Switch(
                  value:
                      controller.profile.profile.value.permission?.videoCall ??
                          false,
                  onChanged: (value) {
                    controller.profile.profile.value.permission!.videoCall =
                        value;
                    controller.submit();
                  },
                ),
              ),
              const Divider(),
              // security
              const ListTile(
                title: Text(
                  "امنیت",
                ),
                dense: true,
              ),
              // phone number
              ListTile(
                onTap: controller.profile.profile.value.verified == true
                    ? null
                    : () {
                        Get.dialog(
                          const DialogChangePhoneView(),
                        );
                      },
                leading: const Icon(Icons.phone_android),
                title: const Text("شماره تلفن"),
                subtitle: Text(controller.profile.profile.value.phone ?? ""),
                trailing: controller.profile.profile.value.verified != true
                    ? const Icon(Icons.edit)
                    : null,
              ),
              // password
              ListTile(
                onTap: () {
                  Get.dialog(
                    const DialogChangePasswordView(),
                  );
                },
                leading: const Icon(Icons.lock),
                title: const Text("رمز عبور"),
                trailing: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
