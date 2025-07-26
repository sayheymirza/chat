import 'package:chat/futures/account_notification/account_notification.controller.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountNotificationView extends GetView<AccountNotificationController> {
  const AccountNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountNotificationController());

    return Scaffold(
      appBar: const GradientAppBarWidget(
        back: true,
        title: "صدا و اعلانات",
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              // title for sounds
              const ListTile(
                title: Text(
                  "لرزش",
                ),
                dense: true,
              ),
              ListTile(
                onTap: () {
                  controller.toggleVibration(!controller.vibration.value);
                },
                leading: const Icon(Icons.vibration),
                title: const Text("لرزش گوشی"),
                trailing: Switch(
                  value: controller.vibration.value,
                  onChanged: (value) {
                    controller.toggleVibration(value);
                  },
                ),
              ),
              const ListTile(
                title: Text(
                  "صدا",
                ),
                dense: true,
              ),
              // chat sound with switch
              ListTile(
                onTap: () {
                  controller.toggleSoundChat(!controller.soundChat.value);
                },
                leading: const Icon(Icons.forum),
                title: const Text("صدای چت"),
                trailing: Switch(
                  value: controller.soundChat.value,
                  onChanged: (value) {
                    controller.toggleSoundChat(value);
                  },
                ),
              ),
              ListTile(
                onTap: () {
                  controller.toggleSoundCall(!controller.soundCall.value);
                },
                leading: const Icon(Icons.ring_volume),
                title: const Text("صدای تماس"),
                trailing: Switch(
                  value: controller.soundCall.value,
                  onChanged: (value) {
                    controller.toggleSoundCall(value);
                  },
                ),
              ),
              const Divider(),
              // title for notifications
              const ListTile(
                title: Text(
                  "اعلانات",
                ),
                dense: true,
              ),
              // reaction notification with switch
              ListTile(
                onTap: () {
                  var value = controller.profile.profile.value.permission
                          ?.notificationReaction ??
                      false;

                  controller.profile.profile.value.permission!
                      .notificationReaction = !value;
                  controller.submit();
                },
                leading: const Icon(Icons.feedback),
                title: const Text("اعلان های جزئیات"),
                trailing: Switch(
                  value: controller.profile.profile.value.permission
                          ?.notificationReaction ??
                      false,
                  onChanged: (value) {
                    controller.profile.profile.value.permission!
                        .notificationReaction = value;
                    controller.submit();
                  },
                ),
              ),
              // chat notification with switch
              ListTile(
                onTap: () {
                  var value = controller
                          .profile.profile.value.permission?.notificationChat ??
                      false;

                  controller.profile.profile.value.permission!
                      .notificationChat = !value;
                  controller.submit();
                },
                leading: const Icon(Icons.chat),
                title: const Text("اعلان های چت"),
                trailing: Switch(
                  value: controller
                          .profile.profile.value.permission?.notificationChat ??
                      false,
                  onChanged: (value) {
                    controller.profile.profile.value.permission!
                        .notificationChat = value;
                    controller.submit();
                  },
                ),
              ),
              // voice call notification with switch
              ListTile(
                onTap: () {
                  var value = controller.profile.profile.value.permission
                          ?.notificationVoiceCall ??
                      false;

                  controller.profile.profile.value.permission!
                      .notificationVoiceCall = !value;
                  controller.submit();
                },
                leading: const Icon(Icons.call),
                title: const Text("اعلان های تماس صوتی"),
                trailing: Switch(
                  value: controller.profile.profile.value.permission
                          ?.notificationVoiceCall ??
                      false,
                  onChanged: (value) {
                    controller.profile.profile.value.permission!
                        .notificationVoiceCall = value;
                    controller.submit();
                  },
                ),
              ),
              // video call notification with switch
              ListTile(
                onTap: () {
                  var value = controller.profile.profile.value.permission
                          ?.notificationVideoCall ??
                      false;

                  controller.profile.profile.value.permission!
                      .notificationVideoCall = !value;
                  controller.submit();
                },
                leading: const Icon(Icons.videocam),
                title: const Text("اعلان های تماس تصویری"),
                trailing: Switch(
                  value: controller.profile.profile.value.permission
                          ?.notificationVideoCall ??
                      false,
                  onChanged: (value) {
                    controller.profile.profile.value.permission!
                        .notificationVideoCall = value;
                    controller.submit();
                  },
                ),
              ),
              Gap(navigationBarHeight + 32),
            ],
          ),
        ),
      ),
    );
  }
}
