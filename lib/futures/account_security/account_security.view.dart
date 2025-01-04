import 'package:chat/futures/account_security/account_security.controller.dart';
import 'package:chat/futures/dialog_change_password/dialog_change_password.view.dart';
import 'package:chat/futures/dialog_change_phone/dialog_change_phone.view.dart';
import 'package:chat/shared/services.dart';
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
                  "دسترسی ها",
                ),
                dense: true,
              ),
              permission(
                icon: Icons.notifications,
                text: "دسترسی به اعلان ها",
                access: controller.permissionToNotification.value,
                onTap: () {
                  Services.permission.ask("notification").then(
                    (value) {
                      controller.init();
                    },
                  );
                },
              ),
              permission(
                icon: Icons.location_on_rounded,
                text: "دسترسی به موقعیت مکانی",
                access: controller.permissionToGPS.value,
                onTap: () {
                  Services.permission.ask("gps").then(
                    (value) {
                      controller.init();
                    },
                  );
                },
              ),
              permission(
                icon: Icons.camera_alt,
                text: "دسترسی به دوربین",
                access: controller.permissionToCamera.value,
                onTap: () {
                  Services.permission.ask("camera").then(
                        (value) {
                      controller.init();
                    },
                  );
                },
              ),
              permission(
                icon: Icons.mic,
                text: "دسترسی به میکروفون",
                access: controller.permissionToMicrophone.value,
                onTap: () {
                  Services.permission.ask("microphone").then(
                    (value) {
                      controller.init();
                    },
                  );
                },
              ),
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

  Widget permission({
    required IconData icon,
    required String text,
    required bool access,
    Function? onTap,
  }) {
    return ListTile(
      onTap: access == true
          ? null
          : () {
              if (onTap != null) {
                onTap();
              }
            },
      leading: Icon(icon),
      title: Text(text),
      trailing: Text(
        access ? "فعال" : "غیرفعال",
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
