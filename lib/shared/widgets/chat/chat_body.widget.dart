import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/widgets/chat/chat_footer/chat_footer.widget.dart';
import 'package:chat/shared/widgets/chat/chat_messages.widget.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatelessWidget {
  final Stream<List<ChatMessageModel>> messages;
  final List<Widget> children;
  final Function onLoadMore;
  final Function onLoadLess;

  const ChatBodyWidget({
    super.key,
    required this.messages,
    required this.onLoadMore,
    required this.onLoadLess,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
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
        ChatMessagesWidget(
          onLoadMore: onLoadMore,
          onLoadLess: onLoadLess,
          messages: messages,
          children: children,
        ),
        // footer
        Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          child: ChatFooterWidget(),
        ),
      ],
    );
  }
}
