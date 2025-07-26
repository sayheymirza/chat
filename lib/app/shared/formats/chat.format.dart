import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/profile.model.dart';

ChatModel fromJsonToChat(Map<String, dynamic> json) {
  var date = json['last_message_at'] ?? json['created_at'];

  var status = 'normal';
  var userId = '';

  // if (json['participant'] == null) {
  //   status = 'deleted';
  // } else {
  //   userId = json['participant']['id'].toString();
  // }

  if (json['participant'] != null) {
    userId = json['participant']['id'].toString();
  } else {
    status = 'deleted';
  }

  if (json['deleted_for'] != null && json['deleted_for'].length == 2) {
    status == 'deleted';
  }

  if (json['participants'] == null || json['participants'].length == 0) {
    status = 'deleted';
  }

  return ChatModel(
    chatId: json['id'].toString(),
    userId: userId,
    user: json['participant'] == null
        ? null
        : ProfileModel(
            id: userId,
            status: 'unknown',
            avatar: json['participant']['avatar'],
            fullname: json['participant']['name'],
            seen: json['participant']['online'].toString().toLowerCase(),
            verified: json['participant']['mobile_phone_active'],
          ),
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

ChatMessageModel fromJsonToMessage(Map<String, dynamic> json) {
  return ChatMessageModel(
    messageId: json['_id'],
    localId: json['local_id'],
    chatId: json['chat_id'],
    senderId: json['sender_id'].toString(),
    status: json['status'] ?? json['is_read'] ? 'seen' : 'sent',
    sentAt: DateTime.parse(json['sent_at']),
    type: json['content']['type'],
    data: json['content']['data'],
    meta: {},
    theme: json['content']['theme'],
    seq: double.parse(json['seq'].toString()),
    replyMessageId: '',
    reaction: '',
  );
}
