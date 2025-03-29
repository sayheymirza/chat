import 'package:chat/models/profile.model.dart';

class HomeComponentModel<T> {
  final int id;
  final String component;
  final String type;
  final T data;

  HomeComponentModel({
    required this.id,
    required this.component,
    required this.type,
    required this.data,
  });
}

class CardDynamicV1Model {
  final List<String> gradientColors;
  final String title;
  final String titleColor;
  final String subtitle;
  final String subtitleColor;
  final String? buttonText;
  final String? buttonOnTap;
  final bool buttonVisable;
  final bool closeable;

  CardDynamicV1Model({
    required this.gradientColors,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.buttonText,
    required this.buttonOnTap,
    required this.buttonVisable,
    required this.closeable,
  });
}

class HomeComponentListProfileV1Model {
  final String title;
  final String icon;
  final String buttonText;
  final String buttonType;
  final List<ProfileSearchModel> profiles;
  final String? emptyText;

  HomeComponentListProfileV1Model({
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.buttonType,
    required this.profiles,
    required this.emptyText,
  });
}

class HomeProfileModel {
  final int id;
  final String name;
  final String avatar;
  final String status;

  HomeProfileModel({
    required this.name,
    required this.avatar,
    required this.status,
    required this.id,
  });
}

class HomeComponentListChatModel {
  // title, icon, button-text, button-type, chats
  final String title;
  final String icon;
  final String buttonText;
  final String buttonType;
  final List<ChatModel> chats;

  HomeComponentListChatModel({
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.buttonType,
    required this.chats,
  });
}

class ChatModel {
  final String name;
  final String avatar;
  final String lastMessage;
  final String lastMessageTime;

  ChatModel({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
