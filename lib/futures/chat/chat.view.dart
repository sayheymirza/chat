import 'package:chat/futures/chat/chat.controller.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:chat/shared/widgets/chat/chat_body.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());

    return Scaffold(
      appBar: appBar(),
      body: GetBuilder<ChatController>(
        builder: (controller) => ChatBodyWidget(
          messages: controller.messages,
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
        stream: controller.profileStream.stream,
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

          return GradientAppBarWidget(
            back: true,
            right: GestureDetector(
              onTap: () {
                if (Get.previousRoute == '/profile/${data.id}') {
                  Get.back();
                } else {
                  Get.toNamed('/profile/${data.id}', arguments: {
                    'options': true,
                  });
                }
              },
              child: Row(
                children: [
                  AvatarWidget(
                    seen: data.seen!,
                    url: data.avatar!,
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
                          data.fullname!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(2),
                        if (data.status == "typing")
                          Text(
                            "در حال نوشتن ...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (data.status == "online")
                          Text(
                            "آنلاین",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (data.status != "online")
                          Text(
                            formatAgo(data.lastAt.toString()),
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
            left: Row(
              children: [
                // call buttons
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.videocam_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.call_rounded,
                    color: Colors.white,
                  ),
                ),
                // menu button
                PopupMenuButton(
                  child: const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case "block":
                        controller.block();
                        break;
                      case "report":
                        controller.report(
                          fullname: data.fullname!,
                        );
                        break;
                      case "delete":
                        controller.delete();
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: "block",
                        child: Row(
                          children: [
                            Icon(Icons.block),
                            SizedBox(width: 10),
                            Text(
                              "بلاک کردن",
                            ),
                          ],
                        ),
                      ),
                      // report
                      const PopupMenuItem(
                        value: "report",
                        child: Row(
                          children: [
                            Icon(Icons.report),
                            SizedBox(width: 10),
                            Text(
                              "گزارش تخلف",
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "حذف چت",
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
