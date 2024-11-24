import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/formats/chat.format.dart';
import 'package:chat/shared/widgets/chat/chat_message_dialog/chat_message_dialog.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessageDialogView extends GetView<ChatMessageDialogController> {
  final ChatMessageModel message;

  const ChatMessageDialogView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ChatMessageDialogController());

    String? url;

    if (message.type!.startsWith('image') ||
        message.type!.startsWith('audio') ||
        message.type!.startsWith('video')) {
      url = message.data['url'];
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const Spacer(),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width - 64),
            child: Center(child: formatChatMessage(message, longPress: false)),
          ),
          const Spacer(),
          Container(
            // height: Get.mediaQuery.padding.bottom +
            //     100 +
            //     32 +
            //     (url == null ? 0 : 64),
            padding: EdgeInsets.only(
              bottom: Get.mediaQuery.padding.bottom + 32,
            ),
            width: Get.width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              children: [
                if (message.status == "sending" ||
                    message.status == "failed" ||
                    message.status == "faild" ||
                    message.status == "unuploaded")
                  ListTile(
                    onTap: () {
                      controller.send(localId: message.localId!);
                    },
                    leading: Transform.flip(
                      flipX: true,
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text('ارسال پیام'),
                  ),
                if (message.localId != null && message.messageId == null)
                  ListTile(
                    onTap: () {
                      controller.cancelSend(localId: message.localId!);
                    },
                    leading: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                    title: Text('حذف پیام برای من'),
                  ),
                if (message.messageId != null)
                  ListTile(
                    onTap: () {
                      controller.deleteForMe(messageId: message.messageId!);
                    },
                    leading: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                    title: Text('حذف پیام برای من'),
                  ),
                if (message.messageId != null)
                  ListTile(
                    onTap: () {
                      controller.deleteForAll(messageId: message.messageId!);
                    },
                    leading: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ),
                    title: Text('حذف پیام برای هر دو'),
                  ),
                if (url != null)
                  ListTile(
                    onTap: () {
                      controller.download(
                        url: url!,
                        category: message.type!.split('@').first,
                      );
                    },
                    leading: Icon(
                      Icons.download_rounded,
                      color: Colors.blue,
                    ),
                    title: Text('دانلود و ذخیره'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
