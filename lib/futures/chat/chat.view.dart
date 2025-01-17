import 'package:chat/futures/chat/chat.controller.dart';
import 'package:chat/futures/dialog_image/dialog_image.view.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:chat/shared/widgets/chat/chat_body/chat_body.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());

    return Obx(
      () {
        Widget error = Container();

        if (controller.chat.value.user!.relation!.blocked == true) {
          error = errorBlocked();
        }

        if (controller.chat.value.user!.relation!.blockedMe == true) {
          error = errorBlockedMe();
        }

        if (controller.chat.value.user!.status!.toLowerCase() ==
            'unsubscribe') {
          error = errorCanceled();
        }

        if (controller.chat.value.user!.status!.toLowerCase() ==
            'left_for_ever') {
          error = errorDeleted();
        }

        return Stack(
          children: [
            Scaffold(
              appBar: appBar(),
              body: ChatBodyWidget(
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
            error,
          ],
        );
      },
    );
  }

  Widget errorBlocked() {
    return alert(
      title: 'کاربر بلاک شده',
      content:
          'شما این کاربر را بلاک کرده اید و امکان مشاهده اطلاعات و ارسال پیام به او وجود ندارد',
      action: OutlinedButton(
        onPressed: () {
          controller.unblock();
        },
        child: const Text('آنبلاک کردن'),
      ),
    );
  }

  Widget errorBlockedMe() {
    return alert(
      title: 'بلاک شده اید',
      content:
          'این کاربر شما را بلاک کرده و امکان مشاهده اطلاعات و ارسال پیام به او وجود ندارد',
    );
  }

  Widget errorCanceled() {
    // کاربر از عضویت خود منصرف شده است ولی امکان بازگشت دارد
    return alert(
      title: 'کاربر از عضویت خود منصرف شده است',
      content:
          'این کاربر از عضویت خود انصراف داده است اما احتمال بازگشت مجدد او وجود دارد',
    );
  }

  Widget errorDeleted() {
    return alert(
      title: 'کاربر حذف شده',
      content: 'این کاربر حساب کاربری خودش را حذف کرده است',
    );
  }

  Widget alert({
    required String title,
    required String content,
    Widget? action,
  }) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: Get.width,
              // white background with 25% opacity
              color: Colors.white.withOpacity(0.25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //   title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(10),
                  // content
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).asGlass(
              blurX: 20,
              blurY: 20,
            ),
            // back button on top right
            Positioned(
              top: Get.mediaQuery.padding.top + 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            //   if action exists Position to bottom and center
            if (action != null)
              Positioned(
                bottom: Get.mediaQuery.padding.bottom + 20,
                left: 20,
                right: 20,
                child: action,
              ),
          ],
        ),
      ),
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
              if (data.permission.contains('CAN_SEE_PROFILE')) {
                Get.toNamed('/app/profile/${data.userId}', arguments: {
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
                          controller.makeCall(mode: 'audio');
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
                          controller.makeCall(mode: 'video');
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
                      case "favorite":
                        controller.favorite();
                        break;
                      case "disfavorite":
                        controller.disfavorite();
                        break;
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
                      case "profile":
                        Get.toNamed('/app/profile/${data.userId}', arguments: {
                          'options': true,
                        });
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      // open profile
                      if (data.permission.contains('CAN_SEE_PROFILE'))
                        const PopupMenuItem(
                          value: "profile",
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 10),
                              Text(
                                "مشاهده پروفایل",
                              ),
                            ],
                          ),
                        ),
                      if (data.permission.contains('CAN_FAVORITE'))
                        controller.chat.value.user?.relation?.favorited == true
                            ? const PopupMenuItem(
                                value: "disfavorite",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "حذف از علاقه مندی ها",
                                    ),
                                  ],
                                ),
                              )
                            : const PopupMenuItem(
                                value: "favorite",
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite),
                                    SizedBox(width: 10),
                                    Text(
                                      "افزودن به علاقه مندی ها",
                                    ),
                                  ],
                                ),
                              ),
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
