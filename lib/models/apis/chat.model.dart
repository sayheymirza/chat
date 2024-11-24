import 'package:chat/models/chat/chat.model.dart';

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
