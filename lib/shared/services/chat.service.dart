import 'dart:convert';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class ChatService extends GetxService {
  RxInt unreadedChats = 0.obs;

  // listen to events
  void listenToEvents() {
    event.on<EventModel>().listen((data) async {
      if (data.event == CHAT_EVENTS.RECIVE_MESSAGE) {
        var value = data.value as ChatMessageModel;

        onReciveMessage(message: value);
      }
    });
  }

  // create chat if not exists from recived message
  // update last message
  void onReciveMessage({required ChatMessageModel message}) async {
    try {
      var chat = await (database.select(database.chatTable)
            ..where((row) => row.chat_id.equals(message.chatId!)))
          .getSingleOrNull();

      if (chat != null) {
        // update last message
        updateLastMessage(chatId: message.chatId!);
      } else {
        createByChatId(chatId: message.chatId!);
      }
    } catch (e) {
      //
    }
  }

  // update last message
  void updateLastMessage({required String chatId}) async {}

  // listen to unreaded chats
  void listenToUnreadedChats() {}

  // create a chat by user id and return new chat id
  Future<String?> createByUserId({required String userId}) async {
    try {
      // 1. check user exists in chat table
      var user = await (database.select(database.chatTable)
            ..where((row) => row.user_id.equals(userId)))
          .getSingleOrNull();

      if (user == null) {
        // 2. create a new chat and save and return chat id
        var resultOfCreate = await ApiService.chat.createWithUserId(
          userId: userId,
        );

        if (resultOfCreate == null) {
          return null;
        }

        await database.into(database.chatTable).insert(
              ChatTableCompanion.insert(
                chat_id: resultOfCreate.chatId,
                user_id: userId,
                permissions: resultOfCreate.permissions,
              ),
            );

        return resultOfCreate.chatId;
      }

      return user.chat_id;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // create a chat by chat id
  createByChatId({required String chatId}) {
    return Exception("create by chat id not implimented");
  }

  // get chat by chat id
  Future<Stream<ChatModel?>> stream({required String chatId}) async {
    log('[chat.service.dart] stream chat with chat id $chatId');

    try {
      var query = database.select(database.chatTable).join([
        drift.innerJoin(
          database.userTable,
          database.userTable.id.equalsExp(
            database.chatTable.user_id,
          ),
        ),
      ])
        ..where(database.chatTable.chat_id.equals(chatId));

      return query.map((row) {
        return ChatModel.fromJson({
          "chat_id": row.rawData.data['chat_table.chat_id'],
          "user_id": row.rawData.data['chat_table.user_id'],
          "user": row.readTable(database.userTable).data,
          "message": jsonDecode(row.rawData.data['chat_table.message']),
          "permissions": row.rawData.data['chat_table.permissions'],
          "typing": row.rawData.data['chat_table.typing'] == 1,
          "unread_count": row.rawData.data['chat_table.unread_count'],
        });
      }).watchSingleOrNull();
    } catch (e) {
      return Stream.value(null);
    }
  }

  // delete chat
  void delete({required String chatId}) async {
    try {
      // 1. delete from database
      await (database.delete(database.chatTable)
            ..where((row) => row.chat_id.equals(chatId)))
          .go();
      // 2. emit to socket
    } catch (e) {
      //
    }
  }

  // select chats (limit and sort by updated_at and join to last message)
  Future<ChatListModel> select({int page = 1, int limit = 12}) async {
    try {
      var query = database.select(database.chatTable).join([
        drift.innerJoin(
          database.userTable,
          database.userTable.id.equalsExp(
            database.chatTable.user_id,
          ),
        ),
      ]);

      query.orderBy(
        [
          drift.OrderingTerm(
              expression: database.chatTable.updated_at,
              mode: drift.OrderingMode.asc),
        ],
      );

      query.limit(limit, offset: (page - 1) * limit);

      var chats = await query.map((row) {
        return ChatModel.fromJson({
          "chat_id": row.rawData.data['chat_table.chat_id'],
          "user_id": row.rawData.data['chat_table.user_id'],
          "user": row.readTable(database.userTable).data,
          "message": jsonDecode(row.rawData.data['chat_table.message']),
          "permissions": row.rawData.data['chat_table.permissions'],
          "typing": row.rawData.data['chat_table.typing'] == 1,
          "unread_count": row.rawData.data['chat_table.unread_count'],
        });
      }).get();

      var count = await database.chatTable.count().getSingle();

      return ChatListModel(
        chats: chats,
        page: page,
        limit: limit,
        last: count ~/ page,
        total: count,
      );
    } catch (e) {
      print(e.toString());

      return ChatListModel(
        page: page,
        limit: limit,
      );
    }
  }

  // clear (clear all chats)
  Future<void> clear() async {
    try {
      var count = await database.delete(database.chatTable).go();
      log('[chat.service.dart] clear over $count chats');
    } catch (e) {
      //
    }
  }
}
