import 'package:chat/futures/account_notification/account_notification.controller.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountNotificationView extends GetView<AccountNotificationController> {
  const AccountNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountNotificationController());

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: "صدا و اعلانات",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // title for sounds
            const ListTile(
              title: Text(
                "صدا",
              ),
              dense: true,
            ),
            // chat sound with switch
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("صدای چت"),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
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
              leading: const Icon(Icons.chat),
              title: const Text("اعلان های جزئیات"),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            // chat notification with switch
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("اعلان های چت"),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            // voice call notification with switch
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text("اعلان های تماس صوتی"),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            // video call notification with switch
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text("اعلان های تماس تصویری"),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
