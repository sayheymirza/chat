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
  String? status;
  int? unreadCount;
  DateTime? updatedAt;

  ChatModel({
    this.chatId,
    this.userId,
    this.user,
    this.message,
    this.permissions,
    this.status,
    this.unreadCount,
    this.updatedAt,
  });

  List<String> get permission => (permissions?.split(',') ?? []);

  factory ChatModel.fromDatabase(ChatTableData data, {ProfileModel? user}) {
    return ChatModel(
      chatId: data.chat_id,
      userId: data.user_id,
      user: user,
      message: ChatMessageModel.fromJson(data.message as Map<String, dynamic>),
      permissions: data.permissions,
      status: 'normal',
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
    status = json['status'];
    unreadCount = json['unread_count'];
    if (json['updated_at'] != null) {
      // if type is int
      if (json['updated_at'] is int) {
        updatedAt =
            DateTime.fromMillisecondsSinceEpoch(json['updated_at'] * 1000);
      } else if (json['updated_at'] is String) {
        updatedAt = DateTime.parse(json['updated_at']);
      } else {
        updatedAt = DateTime.parse(json['updated_at']);
      }
    }
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
    data['status'] = status;
    data['unread_count'] = unreadCount;
    data['updated_at'] = updatedAt;
    return data;
  }
}
