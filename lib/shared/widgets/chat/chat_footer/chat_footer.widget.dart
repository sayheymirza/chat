import 'package:chat/shared/validator.dart';
import 'package:chat/shared/widgets/chat/chat_footer/chat_footer.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatFooterWidget extends GetView<ChatFooterController> {
  final List<String> permissions;
  final Function(bool value)? onPickEmoji;

  const ChatFooterWidget({
    super.key,
    required this.permissions,
    this.onPickEmoji,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ChatFooterController());

    return AnimatedContainer(
      width: double.infinity,
      duration: Duration(seconds: 1),
      child: Column(
        children: [
          footer(),
          emojis(),
        ],
      ),
    );
  }

  Widget footer() {
    return AnimatedContainer(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(24),
      ),
      constraints: BoxConstraints(
        minHeight: 48,
      ),
      duration: Duration(seconds: 1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Voice button
            Obx(() {
              if (controller.visableVoiceButton.value &&
                  permissions.contains('CAN_RECORD_VOICE')) {
                return iconButton(
                  onPressed: permissions.contains('CAN_RECORD_VOICE_WORK')
                      ? () {
                          controller.toggleRecording();
                        }
                      : null,
                  icon: controller.recoring.value
                      ? Icons.send_rounded
                      : Icons.keyboard_voice_rounded,
                  color: Get.theme.colorScheme.onPrimary,
                  backgroundColor: Get.theme.primaryColor,
                  size: 24,
                  flip: controller.recoring.value,
                );
              } else {
                return SizedBox(); // Placeholder when button is not visible
              }
            }),

            // Send button
            Obx(() {
              if (controller.visableSendButton.value &&
                  permissions.contains('CAN_SEND_MESSAGE')) {
                return iconButton(
                  onPressed: permissions.contains('CAN_SEND_MESSAGE_WORK')
                      ? () {
                          controller.sendTextMessage();
                        }
                      : null,
                  icon: Icons.send_rounded,
                  color: Get.theme.colorScheme.onPrimary,
                  backgroundColor: Get.theme.primaryColor,
                  flip: true,
                );
              } else {
                return SizedBox(); // Placeholder when button is not visible
              }
            }),

            if (permissions.contains('CAN_SEND_TEST_MESSAGE'))
              iconButton(
                icon: Icons.send_time_extension_rounded,
                onPressed: permissions.contains('CAN_SEND_TEST_MESSAGE_WORK')
                    ? () {
                        controller.testSendMessages(
                            10, Duration(milliseconds: 300));
                      }
                    : null,
              ),

            // Recording indicator
            Obx(() {
              if (controller.recoring.value) {
                return SizedBox(
                  height: 48,
                  width: Get.width - 78,
                  child: Row(
                    children: [
                      Gap(10),
                      Expanded(
                        child: Text(
                          'برای لغو به سمت چپ بکشید',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Text(controller.recordingDuration.value),
                      Gap(8),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red.shade500,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap(10),
                    ],
                  ),
                );
              } else {
                return SizedBox(); // Placeholder when not recording
              }
            }),

            // Message sending area
            SizedBox(
              width: Get.width - 78,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text input area
                  message(),
                  // Attach button
                  Obx(() {
                    if (controller.visableAttachmentButton.value &&
                        permissions.contains('CAN_SEND_ATTACHMENT')) {
                      return iconButton(
                        onPressed:
                            permissions.contains('CAN_SEND_ATTACHMENT_WORK')
                                ? () {
                                    controller.openAttachment(
                                        permissions: permissions);
                                  }
                                : null,
                        icon: Icons.attach_file_rounded,
                      );
                    } else {
                      return SizedBox(); // Placeholder when button is not visible
                    }
                  }),

                  // Emoji toggle button
                  if (permissions.contains('CAN_PICK_EMOJI'))
                    Obx(() {
                      return iconButton(
                        onPressed: permissions.contains('CAN_PICK_EMOJI_WORK')
                            ? () {
                                controller.toggleVisableEmojis();
                                if (onPickEmoji != null) {
                                  onPickEmoji!(controller.visableEmojis.value);
                                }
                              }
                            : null,
                        icon: controller.visableEmojis.value
                            ? Icons.keyboard_rounded
                            : Icons.emoji_emotions_rounded,
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget message() {
    var placeholder = "";

    if (permissions.contains('PLACEHOLDER_NORMAL')) {
      placeholder = "پیام خود را بنویسید";
    } else if (permissions.contains('PLACEHOLDER_CONFIRM_PHONE')) {
      placeholder = "برای چت کردن ابتدا موبایل خود را تایید کنید";
    } else if (permissions.contains('PLACEHOLDER_NEED_PLAN')) {
      placeholder =
          "جهت ارسال تصویر و چت صوتی و تصویری یکی از طرفین باید حساب کاربری ویژه داشته باشد";
    } else if (permissions.contains('PLACEHOLDER_JUST_NEED_PLAN')) {
      placeholder =
          "فقط میتوانید متن و اموجی ارسال کنید،جهت ارسال تصویر و نیز چت صوتی و تصویری یکی از طرفین باید حساب کاربری ویژه داشته باشد";
    }

    return Expanded(
      child: TextField(
        contextMenuBuilder: permissions.contains('CAN_PASTE_MESSAGE')
            ? (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.editableText(
                  editableTextState: editableTextState,
                );
              }
            : null,
        controller: controller.messageController,
        focusNode: controller.messageFocus,
        enabled: permissions.contains('CAN_TYPE_MESSAGE'),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 10,
          ),
          hintMaxLines: 3,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(4),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        autocorrect: true,
        minLines: 1,
        maxLines: 6,
        onChanged: (value) {
          var text = value;
          // check if number is in the text
          if (!permissions.contains('CAN_SEND_NUMBER')) {
            text = CustomValidator.convertPN2EN(text);

            if (RegExp(r'\d').hasMatch(text)) {
              // replace all numbers with ''
              text = text.replaceAll(RegExp(r'\d'), '');
            }
          }

          controller.changeMessageText(text);
        },
        onSubmitted: permissions.contains('CAN_SUBMIT_MESSAGE_WORK')
            ? (value) {
                controller.changeMessageText(value);
                controller.sendTextMessage();
              }
            : null,
      ),
    );
  }

  Widget iconButton({
    required IconData icon,
    VoidCallback? onPressed,
    VoidCallback? onHold,
    VoidCallback? onHoldEnd,
    VoidCallback? onHoldLeave,
    Color backgroundColor = Colors.transparent,
    Color? color,
    bool flip = false,
    double size = 20,
  }) {
    return GestureDetector(
      onTap: onPressed,
      onTapDown: onHold != null ? (_) => onHold() : null,
      onTapUp: onHoldEnd != null ? (_) => onHoldEnd() : null,
      onTapCancel: onHoldLeave != null ? () => onHoldLeave() : null,
      child: Container(
        width: 38,
        height: 38,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Center(
          child: Transform.flip(
            flipX: flip,
            child: Icon(
              icon,
              color: color ?? Get.theme.primaryColor,
              size: size,
            ),
          ),
        ),
      ),
    );
  }

  Widget emojis() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: controller.visableEmojis.value ? 290 : 0,
        margin: controller.visableEmojis.value
            ? const EdgeInsets.only(top: 10)
            : null,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: EmojiPicker(
          onBackspacePressed: permissions.contains('CAN_BACKSPACE_EMOJI_WORK')
              ? () {
                  controller.changeMessageTextFromController();
                }
              : null,
          onEmojiSelected: permissions.contains('CAN_PICK_EMOJI_WORK')
              ? (_, __) {
                  controller.changeMessageTextFromController();
                }
              : null,
          textEditingController: permissions.contains('CAN_PICK_EMOJI_WORK')
              ? controller.messageController
              : null,
          config: Config(
            height: 290,
            checkPlatformCompatibility: true,
            emojiViewConfig: const EmojiViewConfig(
              backgroundColor: Colors.white,
              columns: 11,
              verticalSpacing: 1,
              horizontalSpacing: 1,
              emojiSizeMax: 24,
              noRecents: Text(
                'تاریخچه خالی است',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
            ),
            categoryViewConfig: CategoryViewConfig(
              indicatorColor: Get.theme.primaryColor,
              iconColorSelected: Get.theme.primaryColor,
              dividerColor: Colors.transparent,
              backspaceColor: Get.theme.primaryColor,
            ),
            bottomActionBarConfig: const BottomActionBarConfig(
              enabled: false,
            ),
          ),
        ),
      ),
    );
  }
}
