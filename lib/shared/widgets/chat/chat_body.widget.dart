import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/widgets/chat/chat_footer/chat_footer.widget.dart';
import 'package:chat/shared/widgets/chat/chat_messages.widget.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatelessWidget {
  final Stream<List<ChatMessageModel>> messages;
  final List<Widget> children;
  final Function onLoadMore;
  final Function onLoadLess;
  final String? error;

  const ChatBodyWidget({
    super.key,
    required this.messages,
    required this.onLoadMore,
    required this.onLoadLess,
    this.children = const [],
    this.error,
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
        if (error == null || error!.isEmpty)
          // footer
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: ChatFooterWidget(),
          ),
        if (error != null && error!.isNotEmpty)
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: Container(
              width: double.infinity,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  error!,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
