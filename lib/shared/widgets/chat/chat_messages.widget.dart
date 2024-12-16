import 'dart:async';

import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/formats/chat.format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessagesWidget extends StatefulWidget {
  final List<Widget> children;
  final Stream<List<ChatMessageModel>> messages;
  final Function onLoadMore;
  final Function onLoadLess;

  const ChatMessagesWidget({
    super.key,
    required this.messages,
    required this.onLoadMore,
    required this.onLoadLess,
    this.children = const [],
  });

  @override
  State<ChatMessagesWidget> createState() => _ChatMessagesWidgetState();
}

class _ChatMessagesWidgetState extends State<ChatMessagesWidget> {
  bool showScrollToBottom = false;
  ScrollController scrollController = ScrollController();
  Timer? timer;

  void onScroll({required double pixels}) {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(Duration(seconds: 1), () {
      // check if scroll to bottom
      if (pixels <= 100) {
        if (showScrollToBottom != false) {
          setState(() {
            showScrollToBottom = false;
          });
        }
      } else {
        if (showScrollToBottom != true) {
          setState(() {
            showScrollToBottom = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          // width: double.infinity,
          // height: double.infinity,
          child: NotificationListener(
            onNotification: (ScrollEndNotification t) {
              if (t.metrics.pixels.toString() == '0.0') {
                widget.onLoadLess();
              } else if (t.metrics.pixels > 0 && t.metrics.atEdge) {
                widget.onLoadMore();
              }

              onScroll(pixels: t.metrics.pixels);

              return true;
            },
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(
                bottom: Get.mediaQuery.padding.bottom + 64,
              ),
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...widget.children,
                  StreamBuilder(
                    stream: widget.messages,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        reverse: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return formatChatMessage(snapshot.data![index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // scroll to bottom (floating action button)
        AnimatedPositioned(
          left: 16,
          bottom: showScrollToBottom ? 85 + Get.mediaQuery.padding.bottom : -100,
          duration: Duration(milliseconds: 200),
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: Get.theme.primaryColor,
            onPressed: () {
              // scroll to bottom
              scrollController.animateTo(
                0.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );

              showScrollToBottom = false;

              setState(() {});
            },
            child: Icon(
              Icons.arrow_downward,
              color: Get.theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
