import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/database/database.dart';

class AdminListModel {
  List<AdminModel>? chats;
  int? page;
  int? limit;
  int? last;
  int? total;

  AdminListModel({
    this.chats = const [],
    this.page = 0,
    this.limit = 0,
    this.last = 0,
    this.total = 0,
  });
}

class AdminModel {
  String? chatId;
  String? title;
  String? subtitle;
  String? image;
  ChatMessageModel? message;
  String? permissions;
  String? status;
  int? unreadCount;
  DateTime? updatedAt;

  AdminModel({
    this.chatId,
    this.title,
    this.subtitle,
    this.image,
    this.message,
    this.permissions,
    this.status,
    this.unreadCount,
    this.updatedAt,
  });

  List<String> get permission => (permissions?.split(',') ?? []);

  factory AdminModel.fromDatabase(AdminChatTableData data) {
    return AdminModel(
      chatId: data.chat_id,
      title: data.title,
      subtitle: data.subtitle,
      image: data.image,
      message: ChatMessageModel.fromJson(data.message as Map<String, dynamic>),
      permissions: data.permissions,
      status: 'normal',
      unreadCount: data.unread_count,
      updatedAt: data.updated_at,
    );
  }

  AdminModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
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
        updatedAt = json['updated_at'];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['image'] = image;
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
