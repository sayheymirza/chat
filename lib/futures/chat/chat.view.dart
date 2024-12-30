import 'package:chat/futures/chat/chat.controller.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:chat/shared/widgets/chat/chat_body/chat_body.widget.dart';
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
      body: Obx(() {
        var error = '';

        if (controller.chat.value.user?.relation?.blocked == true) {
          error = 'شما این کاربر را بلاک کرده اید';
        }

        if (controller.chat.value.user?.relation?.blockedMe == true) {
          error = 'این کاربر شما را بلاک کرده است';
        }

        return ChatBodyWidget(
          error: error,
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
        );
      }),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 56),
      child: Obx(() {
        var data = controller.chat.value;

        if (data.userId == null) {
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
          left: Row(
            children: [
              // call buttons
              if (data.permission.contains('CAN_VOICE_CALL'))
                IconButton(
                  onPressed: data.permission.contains('ALLOW_VOICE_CALL') &&
                          !controller.makingCall.value
                      ? () {
                          Services.call.make(mode: 'audio');
                        }
                      : null,
                  icon: Icon(
                    Icons.call_rounded,
                    color: data.permission.contains('ALLOW_VOICE_CALL')
                        ? Colors.red
                        : Colors.white70,
                  ),
                ),
              if (data.permission.contains('CAN_VIDEO_CALL'))
                IconButton(
                  onPressed: data.permission.contains('ALLOW_VIDEO_CALL') &&
                          !controller.makingCall.value
                      ? () {
                          Services.call.make(mode: 'video');
                        }
                      : null,
                  icon: Icon(
                    Icons.videocam_rounded,
                    color: data.permission.contains('ALLOW_VIDEO_CALL')
                        ? Colors.green
                        : Colors.white70,
                  ),
                ),
              // menu button
              if (data.permission.contains('CAN_SEE_MENU'))
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
                      case "unblock":
                        controller.unblock();
                        break;
                      case "report":
                        controller.report();
                        break;
                      case "delete":
                        controller.delete();
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      if (data.permission.contains('CAN_BLOCK'))
                        controller.chat.value.user?.relation?.blocked == false
                            ? const PopupMenuItem(
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
                              )
                            : const PopupMenuItem(
                                value: "unblock",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.block,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "آنبلاک کردن",
                                    ),
                                  ],
                                ),
                              ),
                      // report
                      if (data.permission.contains('CAN_REPORT'))
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
                      if (data.permission.contains('CAN_DELETE_CHAT'))
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
      }),
    );
  }
}
