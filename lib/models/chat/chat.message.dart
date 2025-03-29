import 'package:chat/shared/database/database.dart';

class ChatMessageModel {
  String? messageId;
  String? localId;
  String? chatId;
  String? senderId;
  String? status;
  DateTime? sentAt;
  String? type;
  dynamic? data;
  dynamic? meta;
  dynamic? theme;
  double? seq;
  String? replyMessageId;
  String? reaction;

  ChatMessageModel({
    this.messageId,
    this.localId,
    this.chatId,
    this.senderId,
    this.status,
    this.sentAt,
    this.type,
    this.data,
    this.meta,
    this.theme,
    this.seq,
    this.replyMessageId,
    this.reaction,
  });

  toData() {
    return data;
  }

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    localId = json['local_id'];
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    status = json['status'];
    if (json['sent_at'] != null || json['sent_at'] != "null") {
      // if sent_at is string parse to DateTime else do nothing
      if (json['sent_at'] is String) {
        sentAt = DateTime.parse(json['sent_at']);
      } else {
        sentAt = json['sent_at'];
      }
    }
    type = json['type'];
    data = json['data'];
    meta = json['meta'];
    theme = json['theme'];
    seq = json['seq'];
    replyMessageId = json['reply_message_id'];
    reaction = json['reaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = messageId;
    data['local_id'] = localId;
    data['chat_id'] = chatId;
    data['sender_id'] = senderId;
    data['status'] = status;
    data['sent_at'] = sentAt?.toString();
    data['type'] = type;
    data['data'] = toData();
    data['meta'] = meta;
    data['theme'] = theme;
    data['seq'] = seq;
    data['reply_message_id'] = replyMessageId;
    data['reaction'] = reaction;
    return data;
  }

  MessageTableData toDatabase() {
    return MessageTableData(
      id: 0,
      message_id: messageId!,
      local_id: localId!,
      chat_id: chatId!,
      status: status ?? "unknown",
      sender_id: senderId!,
      sent_at: sentAt!,
      type: type!,
      data: data,
      meta: meta,
      theme: theme,
      seq: seq ?? 0,
      reaction: reaction,
    );
  }

  factory ChatMessageModel.fromDatabase(MessageTableData data) {
    return ChatMessageModel(
      messageId: data.message_id,
      localId: data.local_id,
      chatId: data.chat_id,
      senderId: data.sender_id,
      status: data.status,
      sentAt: data.sent_at,
      type: data.type,
      data: data.data,
      meta: data.meta,
      theme: data.theme,
      seq: data.seq,
      reaction: data.reaction,
    );
  }
}
