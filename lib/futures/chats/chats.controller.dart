import 'dart:convert';

import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class ChatsController extends GetxController {
  RxList<ChatItemModel> chats = List<ChatItemModel>.empty(growable: true).obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxInt limit = 12.obs;
  RxBool loading = false.obs;

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    load();
  }

  void open({required String id}) {
    Get.toNamed('/app/chat/$id')!.then((_) => load());
  }

  void load() async {
    var result = await database
        .customSelect(
          'WITH RankedChats AS ( SELECT chat_table.id AS chat_id, chat_participant_table.user_id AS user_id, chat_table.unread_count AS unread_count, user_table.avatar AS avatar, user_table.fullname AS fullname, user_table.seen AS seen, user_table.status AS status, message_table.type AS message_type, message_table.data AS message_data, message_table.sent_at AS sent_at, ROW_NUMBER() OVER (PARTITION BY chat_table.id ORDER BY message_table.sent_at DESC) as rn FROM chat_table LEFT JOIN message_table ON message_table.chat_id = chat_table.id AND message_table.sent_at = ( SELECT MAX(sent_at) FROM message_table WHERE chat_id = chat_table.id ) JOIN chat_participant_table ON chat_table.id = chat_participant_table.chat_id JOIN user_table ON chat_participant_table.user_id = user_table.id ) SELECT chat_id, user_id, unread_count, avatar, fullname, seen, status, message_type, message_data, sent_at FROM RankedChats WHERE rn = 1 ORDER BY sent_at DESC LIMIT ? OFFSET ?;',
          // 'SELECT '
          // 'chat_table.id AS chat_id, chat_participant_table.user_id AS user_id, chat_table.unread_count AS unread_count, '
          // 'user_table.avatar AS avatar, user_table.fullname AS fullname, user_table.seen AS seen, user_table.status AS status, '
          // 'message_table.type AS message_type, message_table.data AS message_data, message_table.sent_at AS sent_at '
          // 'FROM chat_table '
          // 'LEFT JOIN message_table ON message_table.chat_id = chat_table.id AND message_table.sent_at = ( SELECT MAX(sent_at) FROM message_table WHERE chat_id = chat_table.id )'
          // 'JOIN chat_participant_table ON chat_table.id = chat_participant_table.chat_id '
          // 'JOIN user_table ON chat_participant_table.user_id = user_table.id '
          // 'ORDER BY message_table.sent_at DESC '
          // 'LIMIT ? OFFSET ?'
          // ';',
          variables: [
            drift.Variable(limit.value),
            drift.Variable((page.value - 1) * limit.value),
          ],
        )
        .map(
          (row) => ChatItemModel(
            id: row.data['chat_id'],
            avatar: row.data['avatar'],
            fullname: row.data['fullname'],
            seen: row.data['seen'],
            status: row.data['status'],
            sentAt: row.data['sent_at'] == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(
                        row.data['sent_at'] * 1000)
                    .toString(),
            count: row.data['unread_count'],
            messageType: row.data['message_type'],
            messageData: row.data['message_data'] == null
                ? {}
                : jsonDecode(row.data['message_data']),
          ),
        )
        .get();

    chats.value = result;
  }
}
