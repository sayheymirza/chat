import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDeleteLeaveChooseView extends StatelessWidget {
  const AccountDeleteLeaveChooseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: 'غیر فعال سازی و حذف',
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            title: const Text('حذف حساب کاربری'),
            onTap: () {
              Get.toNamed('/app/account_delete_leave/delete');
              NavigationToNamed('/app/account_delete_leave/delete');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.handshake_rounded,
              color: Colors.amber,
            ),
            title: const Text('انصراف از عضویت'),
            onTap: () {
              Get.toNamed('/app/account_delete_leave/leave');
              NavigationToNamed('/app/account_delete_leave/leave');
            },
          ),
        ],
      ),
    );
  }
}
