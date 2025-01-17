import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_audio_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_call_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_deleted.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_image_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_map_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_not_support.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_text_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_video_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_voice_v1.widget.dart';
import 'package:flutter/material.dart';

Widget formatChatMessage(
  ChatMessageModel item, {
  bool action = true,
}) {
  var key = ValueKey("${item.localId}");

  if (item.status == "deleted") {
    return ChatMessageDeletedWidget(
      message: item,
      key: key,
      action: action,
    );
  }

  switch (item.type) {
    case "video@v1":
      return ChatMessageVideoV1Widget(
        message: item,
        key: key,
        action: action,
      );
    case "audio@v1":
      return ChatMessageAudioV1Widget(
        message: item,
        key: key,
        action: action,
      );
    case "voice@v1":
      return ChatMessageVoiceV1Widget(
        message: item,
        key: key,
        action: action,
      );
    case "text@v1":
      return ChatMessageTextV1Widget(
        message: item,
        key: key,
        action: action,
      );
    case "image@v1":
      return ChatMessageImageV1Widget(
        message: item,
        key: key,
        action: action,
      );
    case "map@v1":
      return ChatMessageMapV1Widget(
        message: item,
        key: key,
        action: action,
      );
    case "call@v1":
      return ChatMessageCallV1Widget(
        message: item,
        key: key,
        action: action,
      );
    default:
      return ChatMessageNotSupportWidget(
        message: item,
        key: key,
        action: action,
      );
  }
}
