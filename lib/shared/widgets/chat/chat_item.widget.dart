import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatModel item;
  final Function onTap;

  const ChatItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          children: [
            // avatar
            AvatarWidget(
              url: item.user!.avatar!,
              seen: item.user!.seen!,
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    child: Text(
                      item.user!.fullname!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Gap(4),
                  message(
                    type: item.message?.type ?? 'empty',
                    data: item.message?.data ?? {},
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Opacity(
                  opacity:
                      item.unreadCount == null || item.unreadCount == 0 ? 0 : 1,
                  child: Container(
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        item.unreadCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Get.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(4),
                if (item.updatedAt != null)
                  Text(
                    formatAgoChat(item.updatedAt!.toString()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget message({
    required String type,
    required dynamic data,
  }) {
    IconData icon = Icons.message_rounded;
    String text = '';

    if (type == "empty") {
      icon = Icons.question_answer;
      text = 'گفتگوی جدید';
    } else if (type.startsWith('text')) {
      icon = Icons.message_rounded;
      text = data['text'] ?? '';
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
        ),
        const Gap(4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
