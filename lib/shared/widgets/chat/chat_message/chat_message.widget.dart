import 'package:bubble/bubble.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/formats/byte.format.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message_dialog/chat_message_dialog.view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatMessageWidget extends StatelessWidget {
  ChatMessageModel message;
  Widget child;
  Color? color;
  bool longPress;

  ChatMessageWidget({
    super.key,
    required this.message,
    required this.child,
    this.color,
    this.longPress = true,
  });

  @override
  Widget build(BuildContext context) {
    bool me = message.senderId == Services.profile.profile.value.id!;

    BubbleNip? nip = me ? BubbleNip.rightBottom : BubbleNip.leftBottom;
    BubbleEdges? padding;

    color ??= me ? Get.theme.primaryColor.withAlpha(72) : Colors.grey.shade100;

    if (message.type!.startsWith("map") ||
        message.type!.startsWith('image') ||
        message.type!.startsWith('video')) {
      nip = BubbleNip.no;
      padding = BubbleEdges.all(0);
    }

    return GestureDetector(
      onLongPress: !longPress
          ? null
          : () {
              Get.bottomSheet(
                ChatMessageDialogView(
                  message: message,
                ),
                isDismissible: true,
                isScrollControlled: true,
              );
            },
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Bubble(
              alignment: me ? Alignment.topRight : Alignment.topLeft,
              nipOffset: 0.0,
              stick: true,
              padding: padding,
              nipRadius: 1.0,
              nipWidth: 12,
              nipHeight: 8,
              nip: nip,
              color: color,
              elevation: 0,
              child: child,
            ),
            const Gap(4),
            Row(
              mainAxisAlignment:
                  me ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                // if sent
                if (message.status == 'sending')
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                      Gap(8),
                      // date time
                      Text(
                        "در حال ارسال",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (message.status == 'sent')
                  Row(
                    children: [
                      Icon(
                        Icons.done_rounded,
                        size: 14,
                        color: Colors.green,
                      ),
                      Gap(8),
                      // date time
                      Text(
                        formatAgoChatMessage(message.sentAt.toString()),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (message.status == "faild" || message.status == "unuploaded")
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 14,
                        color: Colors.red,
                      ),
                      Gap(8),
                      Text(
                        'ارسال نشد',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                // if visited
                // if uploading
                if (message.status == "uploading")
                  Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          value:
                              double.parse(message.meta['percent'].toString()) /
                                  100,
                          strokeWidth: 2,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '${message.meta['percent']}%',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '${formatBytes(message.meta['sent'])}/${formatBytes(message.meta['total'])}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
