import 'dart:async';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/formats/chat.format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessagesController extends GetxController {
  var showScrollToBottom = false.obs;
  final ScrollController scrollController = ScrollController();
  Timer? timer;

  void onScroll(double pixels) {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(Duration(seconds: 1), () {
      if (pixels <= 100) {
        if (showScrollToBottom.value != false) {
          showScrollToBottom.value = false;
        }
      } else {
        if (showScrollToBottom.value != true) {
          showScrollToBottom.value = true;
        }
      }
    });
  }

  void scrollToBottom() {
    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    showScrollToBottom.value = false;
  }
}

class ChatMessagesWidget extends StatelessWidget {
  final List<Widget> children;
  final List<ChatMessageModel> messages;
  final Function onLoadMore;
  final Function onLoadLess;
  final double bottom;

  ChatMessagesWidget({
    super.key,
    required this.messages,
    required this.onLoadMore,
    required this.onLoadLess,
    this.children = const [],
    this.bottom = 0,
  });

  final ChatMessagesController chatController =
      Get.put(ChatMessagesController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: bottom,
          duration: Duration(milliseconds: 100),
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (t) {
              if (t.metrics.pixels == 0.0) {
                onLoadLess();
              } else if (t.metrics.pixels > 0 && t.metrics.atEdge) {
                onLoadMore();
              }

              chatController.onScroll(t.metrics.pixels);
              return true;
            },
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(
                bottom: Get.mediaQuery.padding.bottom + 64,
              ),
              controller: chatController.scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ListView.builder(
                  //   reverse: false,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: messages.length,
                  //   itemBuilder: (context, index) {
                  //     return formatChatMessage(messages[index]);
                  //   },
                  // ),
                  ...messages.map((message) => formatChatMessage(message)),
                  ...children,
                ],
              ),
            ),
          ),
        ),

        // scroll to bottom (floating action button)
        Obx(() => AnimatedPositioned(
              left: 16,
              bottom: chatController.showScrollToBottom.value
                  ? 85 + Get.mediaQuery.padding.bottom
                  : -100,
              duration: Duration(milliseconds: 200),
              child: FloatingActionButton(
                shape: CircleBorder(),
                backgroundColor: Get.theme.primaryColor,
                onPressed: chatController.scrollToBottom,
                child: Icon(
                  Icons.arrow_downward,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            )),
      ],
    );
  }
}
