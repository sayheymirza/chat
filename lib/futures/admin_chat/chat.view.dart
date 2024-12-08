import 'package:chat/futures/admin_chat/chat.controller.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:chat/shared/widgets/chat/chat_body.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdminChatView extends GetView<AdminChatController> {
  const AdminChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminChatController());

    return Scaffold(
      appBar: appBar(),
      body: GetBuilder<AdminChatController>(
        builder: (controller) => ChatBodyWidget(
          messages: controller.messageStream.stream,
          children: controller.children,
          onLoadMore: () {
            controller.loadMessages();
          },
          onLoadLess: () {
            // controller.loadMessages(pageValue: max(controller.page - 2, 0));
          },
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 56),
      child: StreamBuilder(
        stream: controller.chatStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return GradientAppBarWidget(
              back: true,
              title: "خطایی رخ داد",
            );
          }

          var data = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting ||
              data == null) {
            return GradientAppBarWidget(back: true);
          }

          data.status ??= 'normal';

          return GradientAppBarWidget(
            back: true,
            right: GestureDetector(
              onTap: () {
                if (Get.previousRoute == '/profile/${data.userId}') {
                  Get.back();
                } else {
                  Get.toNamed('/profile/${data.userId}', arguments: {
                    'options': true,
                  });
                }
              },
              child: Row(
                children: [
                  AvatarWidget(
                    seen: data.user!.seen!,
                    url: data.user!.avatar!,
                    size: 42,
                  ),
                  const Gap(14),
                  SizedBox(
                    width: Get.width - 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(6),
                        Text(
                          data.user!.fullname!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(2),
                        if (data.status == 'typing')
                          Text(
                            "در حال نوشتن ...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (data.status == 'normal' &&
                            data.user?.seen == "online")
                          Text(
                            "آنلاین",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (data.status == 'normal' &&
                            data.user?.seen != "online")
                          Text(
                            formatAgo(data.user!.lastAt.toString()),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
