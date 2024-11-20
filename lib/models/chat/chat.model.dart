import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/database/database.dart';

class ChatListModel {
  List<ChatModel>? chats;
  int? page;
  int? limit;
  int? last;
  int? total;

  ChatListModel({
    this.chats = const [],
    this.page = 0,
    this.limit = 0,
    this.last = 0,
    this.total = 0,
  });
}

class ChatModel {
  String? chatId;
  String? userId;
  ProfileModel? user;
  ChatMessageModel? message;
  String? permissions;
  bool? typing;
  int? unreadCount;
  DateTime? updatedAt;

  ChatModel({
    this.chatId,
    this.userId,
    this.user,
    this.message,
    this.permissions,
    this.typing,
    this.unreadCount,
    this.updatedAt,
  });

  factory ChatModel.fromDatabase(ChatTableData data, {ProfileModel? user}) {
    return ChatModel(
      chatId: data.chat_id,
      userId: data.user_id,
      user: user,
      message: ChatMessageModel.fromJson(data.message as Map<String, dynamic>),
      permissions: data.permissions,
      typing: data.typing,
      unreadCount: data.unread_count,
      updatedAt: data.updated_at,
    );
  }

  ChatModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    userId = json['user_id'];
    user =
        json['user'] != null ? ProfileModel.fromDatabase(json['user']) : null;
    message = json['message'] != null
        ? ChatMessageModel.fromJson(json['message'])
        : null;
    permissions = json['permissions'];
    typing = json['typing'];
    unreadCount = json['unread_count'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['user_id'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['permissions'] = permissions;
    data['typing'] = typing;
    data['unread_count'] = unreadCount;
    data['updated_at'] = updatedAt;
    return data;
  }
}
