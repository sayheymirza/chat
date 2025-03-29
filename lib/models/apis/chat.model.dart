import 'package:chat/models/chat/admin.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';

enum ApiChatMessageOperator { BEFORE, AFTER }

class ApiChatCallResponse {
  final String? token;
  final String message;
  final bool inCall;

  ApiChatCallResponse({
    required this.token,
    required this.message,
    this.inCall = false,
  });
}

class ApiChatMessagesResponse {
  final List<ChatMessageModel> messages;
  final DateTime? syncDate;

  ApiChatMessagesResponse({
    required this.messages,
    required this.syncDate,
  });
}

class ApiChatCreateWithUserResponse {
  final String chatId;
  final String permissions;

  ApiChatCreateWithUserResponse({
    required this.chatId,
    required this.permissions,
  });
}

class ApiChatCreateWithChatResponse {
  final String userId;
  final String permissions;
  final int unread_count;

  ApiChatCreateWithChatResponse({
    required this.userId,
    required this.permissions,
    required this.unread_count,
  });
}

class ApiChatOneResponse {
  final String userId;
  final String permissions;
  final int unread_count;

  ApiChatOneResponse({
    required this.userId,
    required this.permissions,
    required this.unread_count,
  });
}

class ApiChatListResponse {
  final int page;
  final int last;
  final int limit;
  final int total;
  final List<ChatModel> chats;

  ApiChatListResponse({
    required this.page,
    required this.last,
    required this.limit,
    required this.total,
    required this.chats,
  });

  static get empty => ApiChatListResponse(
        page: 0,
        limit: 0,
        total: 0,
        last: 0,
        chats: [],
      );
}

class ApiAdminListResponse {
  final int page;
  final int last;
  final int limit;
  final int total;
  final List<AdminModel> chats;

  ApiAdminListResponse({
    required this.page,
    required this.last,
    required this.limit,
    required this.total,
    required this.chats,
  });

  static get empty => ApiAdminListResponse(
        page: 0,
        limit: 0,
        total: 0,
        last: 0,
        chats: [],
      );
}

class ApiAdminChatOneResponse {
  final String title;
  final String subtitle;
  final String image;
  final String permissions;
  final int unread_count;
  final DateTime updated_at;

  ApiAdminChatOneResponse({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.permissions,
    required this.unread_count,
    required this.updated_at,
  });
}
