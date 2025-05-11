import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/formats/byte.format.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_delete_message_dialog/chat_delete_message_dialog.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatMessageWidget extends GetView<ChatMessageController> {
  ChatMessageModel message;
  Widget child;
  Color? color;
  bool action;

  ChatMessageWidget({
    super.key,
    required this.message,
    required this.child,
    this.color,
    this.action = true,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ChatMessageController());

    bool me = message.senderId == Services.profile.profile.value.id! ||
        message.senderId!.isEmpty;

    EdgeInsets? padding = EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    );

    BorderRadius radius = BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(me ? 16 : 0),
      bottomRight: Radius.circular(me ? 0 : 16),
    );

    color ??= !me ? Get.theme.primaryColor.withAlpha(72) : Colors.grey.shade100;

    if (message.status != 'deleted') {
      if (message.type!.startsWith("map") ||
          message.type!.startsWith('image') ||
          message.type!.startsWith('video')) {
        padding = EdgeInsets.all(0);
      }
    }

    Widget footer = Container();

    switch (message.status) {
      case 'notverified':
        footer = Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 16,
              color: Colors.red,
            ),
            Gap(8),
            Text(
              'پیام ارسال نمی‌شود، حساب را تایید کنید.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        );
        break;
      case 'unknown':
        footer = Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ],
        );
        break;
      case 'sending':
        footer = Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: Colors.grey,
            ),
            Gap(8),
            Text(
              "در حال ارسال",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        );
        break;
      case 'sent':
      case 'deleted':
        footer = Row(
          children: [
            Icon(
              Icons.done_rounded,
              size: 16,
              color: Colors.grey.shade700,
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
        );
        break;
      case 'seen':
        footer = Row(
          children: [
            Icon(
              Icons.done_all_rounded,
              size: 16,
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
        );
        break;
      case 'notsend':
      case 'faild':
      case 'failed':
      case 'unuploaded':
        footer = Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 16,
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
        );
        break;
      case 'undownloaded':
        footer = Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 16,
              color: Colors.red,
            ),
            Gap(8),
            Text(
              'دانلود نشد',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        );
        break;
      case 'downlading':
        Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                value: double.parse(message.meta['percent'].toString()) / 100,
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
              '${formatBytes(message.meta['received'] ?? message.meta['recive'] ?? 0)}/${formatBytes(message.meta['total'])}',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        );
        break;
      case 'uploading':
        footer = Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                value: double.parse(message.meta['percent'].toString()) / 100,
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
            // if sent or total is 0
            if (message.meta['sent'] == 0 ||
                message.meta['total'] == 0 ||
                message.meta['sent'] == null ||
                message.meta['total'] == null)
              Text(
                'در حال آپلود',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            if (message.meta['sent'] != 0 &&
                message.meta['total'] != 0 &&
                message.meta['sent'] != null &&
                message.meta['total'] != null)
              Text(
                '${formatBytes(message.meta['sent'])}/${formatBytes(message.meta['total'])}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
          ],
        );
      default:
    }

    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                me ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (!me && action) options(),
              Container(
                clipBehavior: Clip.hardEdge,
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  color: color,
                ),
                child: child,
              ),
              if (me && action) options(),
            ],
          ),
          const Gap(4),
          Row(
            mainAxisAlignment:
                me ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              footer,
            ],
          ),
        ],
      ),
    );
  }

  Widget options() {
    if (message.status == "deleted") return Container();

    // icon button (open dropdown menu) for delete message
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
          if (message.status == "sending" ||
              message.status == "failed" ||
              message.status == "faild" ||
              message.status == "unuploaded")
            PopupMenuItem(
              child: ListTile(
                onTap: () {
                  Get.back();

                  controller.send(message: message);
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
            ),
          if (message.status == "uploading")
            PopupMenuItem(
              child: ListTile(
                onTap: () {
                  Get.back();

                  controller.cancelUpload(message: message);
                },
                leading: Icon(
                  Icons.cancel_outlined,
                  color: Colors.blue,
                ),
                title: Text('انصراف از آپلود'),
              ),
            ),
          if (message.localId != null && message.messageId == null)
            PopupMenuItem(
              child: ListTile(
                onTap: () {
                  Get.back();

                  controller.cancelUpload(message: message);
                  controller.cancelSend(localId: message.localId!);
                },
                leading: Icon(
                  Icons.cancel_schedule_send,
                  color: Colors.red,
                ),
                title: Text('انصراف از ارسال پیام'),
              ),
            ),
          if (message.messageId != null)
            PopupMenuItem(
              child: ListTile(
                onTap: () {
                  Get.back();

                  Get.dialog(
                    ChatDeleteMessageDialog(),
                  ).then((result) {
                    if (result == true) {
                      controller.deleteForAll(messageId: message.messageId!);
                    }

                    if (result == false) {
                      controller.deleteForMe(messageId: message.messageId!);
                    }
                  });
                },
                leading: Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
                title: Text('حذف پیام'),
              ),
            ),
          if (message.data['url'] != null &&
              message.data['url'].startsWith('http'))
            PopupMenuItem(
              child: ListTile(
                onTap: () {
                  Get.back();

                  controller.download(
                    url: message.data['url'],
                    category: message.type!.split('@').first,
                  );
                },
                leading: Icon(
                  Icons.download_rounded,
                  color: Colors.blue,
                ),
                title: Text('دانلود و ذخیره'),
              ),
            ),
        ];
      },
      child: Container(
        padding: EdgeInsets.all(6),
        child: Icon(
          Icons.more_vert_rounded,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
