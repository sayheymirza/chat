import 'package:chat/models/call.model.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogIncomingCallView extends StatelessWidget {
  final IncomingCallModel call;

  const DialogIncomingCallView({
    super.key,
    required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Gap(MediaQuery.of(context).padding.top + 100),
            AvatarWidget(
              seen: 'online',
              url: call.avatar,
              size: 120,
            ),
            const Gap(20),
            Text(
              call.fullname,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(4),
            Text(
              call.mode == 'video' ? 'تماس تصویری' : 'تماس صوتی',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button(
                  onTap: () {
                    Get.back(result: false);
                  },
                  icon: Icons.call_end,
                  color: Colors.red,
                ),
                const Gap(100),
                button(
                  onTap: () {
                    Get.back(result: true);
                  },
                  icon: Icons.call,
                  color: Colors.green,
                ),
              ],
            ),
            Gap(MediaQuery.of(context).padding.bottom + 100),
          ],
        ),
      ),
    );
  }

  Widget button({
    required Function onTap,
    required IconData icon,
    required Color color,
    double size = 64,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
