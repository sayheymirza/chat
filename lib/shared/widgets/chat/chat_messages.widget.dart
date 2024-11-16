import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/formats/chat.format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessagesWidget extends StatelessWidget {
  final List<Widget> children;
  final List<ChatMessageModel> message;
  final Function onLoadMore;
  final Function onLoadLess;

  const ChatMessagesWidget({
    super.key,
    required this.message,
    required this.onLoadMore,
    required this.onLoadLess,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: NotificationListener(
        onNotification: (ScrollEndNotification t) {
          print(t.metrics.pixels.toString());

          if (t.metrics.pixels.toString() == '0.0') {
            onLoadLess();
          } else if (t.metrics.pixels > 0 && t.metrics.atEdge) {
            onLoadMore();
          }

          return true;
        },
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.only(
            bottom: Get.mediaQuery.padding.bottom + 64,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...children,
              ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: message.length,
                itemBuilder: (context, index) {
                  return formatChatMessage(message[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
