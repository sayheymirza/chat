import 'package:chat/futures/admin_chat/chat.controller.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:chat/shared/widgets/chat/chat_body/chat_body.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdminChatView extends GetView<AdminChatController> {
  const AdminChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminChatController());

    return Obx(
      () {
        return Stack(
          children: [
            Scaffold(
              appBar: appBar(),
              body: ChatBodyWidget(
                action: false,
                permissions: controller.chat.value.permission,
                messages: controller.messages.value
                  ..sort((a, b) {
                    return a.seq!.compareTo(b.seq!);
                  }),
                children: controller.children,
                onLoadMore: () {
                  controller.loadMessages();
                },
                onLoadLess: () {
                  // controller.loadMessages(pageValue: max(controller.page - 2, 0));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 56),
      child: Obx(() {
        var data = controller.chat.value;

        data.status ??= 'normal';

        return GradientAppBarWidget(
          back: true,
          right: Row(
            children: [
              AvatarWidget(
                seen: "",
                url: data.image ?? '',
                size: 42,
              ),
              const Gap(14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(6),
                  Text(
                    data.title ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(2),
                  Text(
                    data.subtitle ?? '',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
