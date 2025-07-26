import 'package:chat/models/chat/admin.model.dart';
import 'package:chat/models/chat/chat.message.dart';

AdminModel fromJsonToAdmin(Map<String, dynamic> json) {
  var date = json['last_message_at'] ?? json['created_at'];

  var status = 'normal';

  return AdminModel(
    chatId: json['id'].toString(),
    title: json['title'],
    subtitle: json['sender_name'],
    image: json['avatar'],
    status: status,
    permissions: '',
    unreadCount: json['unread_count'],
    message: json['last_message'] == null
        ? null
        : ChatMessageModel(
            messageId: json['last_message']['_id'],
            chatId: json['last_message']['chat_id'],
            localId: json['last_message']['local_id'],
            senderId: json['last_message']['sender_id'].toString(),
            type: json['last_message']['content']['type'],
            data: json['last_message']['content']['data'],
            theme: json['last_message']['content']['theme'],
          ),
    updatedAt: date == null ? DateTime.now() : DateTime.parse(date),
  );
}
