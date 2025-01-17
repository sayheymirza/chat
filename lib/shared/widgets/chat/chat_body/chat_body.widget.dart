import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/widgets/chat/chat_body/chat_body.controller.dart';
import 'package:chat/shared/widgets/chat/chat_footer/chat_footer.widget.dart';
import 'package:chat/shared/widgets/chat/chat_messages.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBodyWidget extends GetView<ChatBodyController> {
  final List<ChatMessageModel> messages;
  final List<Widget> children;
  final Function onLoadMore;
  final Function onLoadLess;
  final List<String> permissions;
  final bool action;

  const ChatBodyWidget({
    super.key,
    required this.messages,
    required this.onLoadMore,
    required this.onLoadLess,
    this.children = const [],
    this.permissions = const [],
    this.action = true,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ChatBodyController());

    return Stack(
      children: [
        // background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffC9D6FF),
                Color(0xffE1E2E5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // messages
        Obx(
          () => ChatMessagesWidget(
            action: action,
            onLoadMore: onLoadMore,
            onLoadLess: onLoadLess,
            messages: messages,
            bottom: controller.pickingEmoji.value
                ? MediaQuery.of(context).padding.bottom + 280
                : 0,
            children: children,
          ),
        ),
        if (permissions.contains('CAN_SEE_FOOTER'))
          // footer
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: ChatFooterWidget(
              permissions: permissions,
              onPickEmoji: (bool value) {
                controller.pickingEmoji.value = value;
              },
            ),
          ),
      ],
    );
  }
}
