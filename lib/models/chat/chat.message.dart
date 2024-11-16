import 'dart:io';

import 'package:chat/shared/database/database.dart';

class ChatMessageModel {
  late String? id;
  late String? localId;
  late String chatId;
  late String senderId;
  late DateTime sentAt;
  late String type;
  late dynamic data;
  late dynamic meta;
  late String status;
  late bool seen;

  ChatMessageModel({
    required this.id,
    required this.localId,
    required this.chatId,
    required this.senderId,
    required this.sentAt,
    required this.type,
    this.data,
    this.meta,
    this.status = "unknown",
  });

  File? get file =>
      data['url'].toString().startsWith('http') ? null : File(data['url']);

  String? get fileUrl => data['url'];

  set fileUrl(String? url) {
    data['url'] = url;
  }

  String? get fileId => data['file_id'];

  set fileId(String? fileId) {
    data['file_id'] = fileId;
  }

  dynamic toData() {
    return null;
  }

  dynamic toJson() {
    return {
      "id": id,
      "localId": localId,
      "chatId": chatId,
      "senderId": senderId,
      "sentAt": sentAt,
      "type": type,
      "data": toData() ?? data,
      "meta": meta,
      "status": status,
    };
  }

  factory ChatMessageModel.fromDatabase(MessageTableData data) {
    return ChatMessageModel(
      id: data.id,
      localId: data.local_id,
      chatId: data.chat_id,
      senderId: data.sender_id,
      sentAt: data.sent_at,
      type: data.type,
      data: data.data,
      meta: data.meta,
      status: data.status,
    );
  }
}
