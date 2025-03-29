import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/formats/date.format.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatItemWidget extends StatefulWidget {
  final ChatModel item;
  final Function onTap;

  const ChatItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {
  ProfileModel? profile;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  // on change widget.item
  @override
  void didUpdateWidget(covariant ChatItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item != widget.item) {
      loadProfile();
    }
  }

  Future<void> loadProfile() async {
    try {
      var value = await Services.user.one(userId: widget.item.userId!);

      if (value != null) {
        setState(() {
          profile = value;
        });
      } else {
        await Services.user.fetch(userId: widget.item.userId!);
        loadProfile();
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return profile == null
        ? Container()
        : GestureDetector(
            onTap: () {
              widget.onTap();
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
                    url: profile!.avatar!,
                    seen: profile!.seen!,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          child: Text(
                            profile!.fullname!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Gap(4),
                        message(
                          type: widget.item.message?.type ?? 'empty',
                          data: widget.item.message?.toData() ?? {},
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: widget.item.unreadCount == null ||
                                widget.item.unreadCount == 0
                            ? 0
                            : 1,
                        child: Container(
                          height: 24,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              widget.item.unreadCount.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(4),
                      if (widget.item.updatedAt != null)
                        Text(
                          formatAgoChat(widget.item.updatedAt!.toString()),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
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
      String val = data['text'] ?? '';
      val = val.replaceAll('\n', ' ');

      text = val.substring(0, val.length < 20 ? val.length : 20);
      if (val.length > 20) {
        text += '...';
      }
    } else if (type.startsWith('voice')) {
      icon = Icons.mic_rounded;
      text = 'پیام صوتی';
    } else if (type.startsWith('audio')) {
      icon = Icons.audiotrack_rounded;
      text = 'موزیک';
    } else if (type.startsWith('video')) {
      icon = Icons.movie_rounded;
      text = 'فیلم';
    } else if (type.startsWith('map')) {
      icon = Icons.location_on;
      text = 'موقعیت مکانی';
    } else if (type.startsWith('image')) {
      icon = Icons.image_rounded;
      text = 'تصویر';
    } else if (type.startsWith('call')) {
      icon = Icons.call_rounded;
      text = 'تماس';
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
