import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_audio_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_image_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_map_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_not_support.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_text_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_video_v1.widget.dart';
import 'package:chat/shared/widgets/chat/chat_message/chat_message_voice_v1.widget.dart';
import 'package:flutter/material.dart';

Widget formatChatMessage(
  ChatMessageModel item, {
  bool longPress = true,
}) {
  var userId = Services.profile.profile.value.id!;

  switch (item.type) {
    case "video@v1":
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        me: item.senderId == userId,
        child: ChatMessageVideoV1Widget(
          url: item.data['url'],
          size: item.data['size'],
          duration: item.data['duration'],
        ),
      );
    case "audio@v1":
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        me: item.senderId == userId,
        child: ChatMessageAudioV1Widget(
          url: item.data['url'],
          size: item.data['size'],
          duration: item.data['duration'],
        ),
      );
    case "voice@v1":
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        me: item.senderId == userId,
        child: ChatMessageVoiceV1Widget(
          url: item.data['url'],
          size: item.data['size'],
          duration: item.data['duration'],
          waveframe: item.data['waveform'],
        ),
      );
    case "text@v1":
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        me: item.senderId == userId,
        child: ChatMessageTextV1Widget(
          text: item.data?['text'] ?? '',
        ),
      );
    case "image@v1":
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        me: item.senderId == userId,
        child: ChatMessageImageV1Widget(
          url: item.data['url'],
        ),
      );
    case "map@v1":
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        me: item.senderId == userId,
        child: ChatMessageMapV1Widget(
          lat: double.parse(item.data['lat'].toString()),
          lon: double.parse(item.data['lon'].toString()),
          zoom: double.parse(item.data['zoom'].toString()),
          image: item.data['url'],
        ),
      );
    default:
      return ChatMessageWidget(
        message: item,
        longPress: longPress,
        color: Colors.red.withAlpha(64),
        child: ChatMessageNotSupportWidget(),
      );
  }
}
