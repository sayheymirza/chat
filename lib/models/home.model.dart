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

class HomeComponentListProfileV1Model {
  final String title;
  final String icon;
  final String buttonText;
  final String buttonType;
  final List<ProfileSearchModel> profiles;

  HomeComponentListProfileV1Model({
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.buttonType,
    required this.profiles,
  });
}

class ProfileModel {
  final String name;
  final String avatar;
  final String status;

  ProfileModel({
    required this.name,
    required this.avatar,
    required this.status,
    required id,
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
