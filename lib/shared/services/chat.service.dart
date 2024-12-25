import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/socket.model.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class ChatService extends GetxService {
  // sync api with database
  Future<void> syncAPIWithDatabase() async {
    try {
      var lastSyncDate = await Services.sync.get(category: 'chat');

      var page = 1;

      do {
        var result = await ApiService.chat.list(
          page: page,
          limit: 20,
          syncDate: lastSyncDate,
        );

        log('[chat.service.dart] syncing api with database on page $page got ${result.chats.length} chats');

        for (var chat in result.chats) {
          var data = ChatTableCompanion(
            chat_id: drift.Value(chat.chatId!),
            user_id: drift.Value(chat.userId!),
            message: drift.Value(
              chat.message?.toJson() ?? {},
            ),
            // permissions: drift.Value(''),
            status: drift.Value('normal'),
            unread_count: drift.Value(chat.unreadCount!),
            updated_at: drift.Value(chat.updatedAt!),
          );

          await database.transaction(() async {
            // 1. find one
            var one = await (database.select(database.chatTable)
                  ..where((row) => row.chat_id.equals(chat.chatId!)))
                .getSingleOrNull();
            // 2. create
            if (one == null) {
              log('[chat.service.dart] sync create chat with chat id ${chat.chatId}');

              // set data permissions to empty string
              data = data.copyWith(permissions: drift.Value(''));

              var result = await database
                  .into(database.chatTable)
                  .insertReturningOrNull(data);
              print(result);
            }
            // 3. update
            else {
              log('[chat.service.dart] sync update chat with chat id ${chat.chatId}');
              await (database.update(database.chatTable)
                    ..where((row) => row.chat_id.equals(chat.chatId!)))
                  .write(data);
            }

            // 4. check user id exists or not
            var user = await (database.select(database.userTable)
                  ..where((row) => row.id.equals(chat.userId!)))
                .getSingleOrNull();

            if (user == null) {
              await Services.user.fetch(userId: chat.userId!);
            }
          });
        }

        if (result.last >= page || result.last == 0) {
          // save new last sync date
          await Services.sync.set(
            category: 'chat',
            syncedAt: DateTime.now(),
          );

          break;
        } else {
          page += 1;
        }
      } while (true);
    } catch (e) {
      print(e);
    }
  }

  // listen to events
  void listenToEvents() {
    event.on<EventModel>().listen((data) async {
      if (data.event == SOCKET_EVENTS.CONNECTED) {
        syncAPIWithDatabase();
      }

      if (data.event == CHAT_EVENTS.ON_RECEIVE_MESSAGE) {
        var value = data.value as ChatMessageModel;

        onReciveMessage(message: value);
      }

      if (data.event == CHAT_EVENTS.DELETE_CHAT) {
        var value = data.value as String;

        // delete chat
        delete(chatId: value);
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

      Timer(Duration(milliseconds: 100), () {
        if (chat != null) {
          log('[chat.service.dart] on receive message for chat id ${message.chatId} need update');
          // update last message
          updateLastMessage(chatId: message.chatId!);
        } else {
          log('[chat.service.dart] on receive message for chat id ${message.chatId} need create');
          createByChatId(chatId: message.chatId!, message: message);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // update last message
  Future<void> updateLastMessage({required String chatId}) async {
    try {
      // 1. get last message that exists
      var last = await (database.select(database.messageTable)
            ..where((row) =>
                row.chat_id.equals(chatId) & row.status.equals('deleted').not())
            ..limit(1)
            ..orderBy([
              (row) => drift.OrderingTerm(
                    expression: row.sent_at,
                    mode: drift.OrderingMode.desc,
                  ),
            ]))
          .getSingleOrNull();

      if (last != null) {
        var message = ChatMessageModel.fromDatabase(last);

        await (database.update(database.chatTable)
              ..where((row) => row.chat_id.equals(chatId)))
            .write(
          ChatTableCompanion(
            message: drift.Value(message.toJson()),
            updated_at: drift.Value(message.sentAt!),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // listen to unreaded chats
  Stream<int> listenToUnreadedChats() {
    return (database.selectOnly(database.chatTable)
          ..addColumns([database.chatTable.unread_count.sum()]))
        .map((row) => row.read(database.chatTable.unread_count.sum()) ?? 0)
        .watchSingle();
  }

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
                updated_at: DateTime.now(),
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
  Future<String?> createByChatId({
    required String chatId,
    ChatMessageModel? message,
  }) async {
    try {
      var result = await ApiService.chat.createWithChatId(chatId: chatId);

      if (result != null) {
        await database.into(database.chatTable).insert(
              ChatTableCompanion.insert(
                chat_id: chatId,
                user_id: result.userId,
                unread_count: drift.Value(result.unread_count),
                message: drift.Value(message != null ? message.toJson() : {}),
                updated_at: message == null ? DateTime.now() : message.sentAt!,
              ),
            );

        return chatId;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // get chat by chat id and create if not exists else update it
  Future<bool> one({required String chatId}) async {
    try {
      var result = await ApiService.chat.one(chatId: chatId);

      if (result != null) {
        await database.transaction(() async {
          // 1. find one
          var one = await (database.select(database.chatTable)
                ..where((row) => row.chat_id.equals(chatId)))
              .getSingleOrNull();
          // 2. create
          if (one == null) {
            await database.into(database.chatTable).insert(
                  ChatTableCompanion.insert(
                    chat_id: chatId,
                    user_id: result.userId,
                    permissions: drift.Value(result.permissions),
                    unread_count: drift.Value(result.unread_count),
                    updated_at: DateTime.now(),
                  ),
                );
          }
          // 3. update
          else {
            await (database.update(database.chatTable)
                  ..where((row) => row.chat_id.equals(chatId)))
                .write(
              ChatTableCompanion(
                user_id: drift.Value(result.userId),
                permissions: drift.Value(result.permissions),
                unread_count: drift.Value(result.unread_count),
              ),
            );
          }
        });

        // update last message for chat
        await updateLastMessage(chatId: chatId);

        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
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
  Future<bool> delete({required String chatId}) async {
    try {
      await (database.delete(database.chatTable)
            ..where((row) => row.chat_id.equals(chatId)))
          .go();
      return true;
    } catch (e) {
      return false;
    }
  }

  // select chats (limit and sort by updated_at and join to last message) steam
  Future<Stream<ChatListModel>> list({int page = 1, int limit = 12}) async {
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
              mode: drift.OrderingMode.desc),
        ],
      );

      query.limit(limit, offset: (page - 1) * limit);

      var count = await database.chatTable.count().getSingle();

      return query
          .map((row) {
            return ChatModel.fromJson({
              "chat_id": row.rawData.data['chat_table.chat_id'],
              "user_id": row.rawData.data['chat_table.user_id'],
              "user": row.readTable(database.userTable).data,
              "message": jsonDecode(row.rawData.data['chat_table.message']),
              "permissions": row.rawData.data['chat_table.permissions'],
              "status": row.rawData.data['chat_table.status'],
              "unread_count": row.rawData.data['chat_table.unread_count'],
              'updated_at': row.rawData.data['chat_table.updated_at'],
            });
          })
          .watch()
          .map((chats) {
            var last = count ~/ limit;

            return ChatListModel(
              chats: chats,
              page: page,
              limit: limit,
              last: last,
              total: count,
            );
          });
    } catch (e) {
      return Stream.value(ChatListModel(
        page: page,
        limit: limit,
      ));
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
              mode: drift.OrderingMode.desc),
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
          "status": row.rawData.data['chat_table.status'],
          "unread_count": row.rawData.data['chat_table.unread_count'],
          'updated_at': row.rawData.data['chat_table.updated_at'],
        });
      }).get();

      var count = await database.chatTable.count().getSingle();

      // last page by devide count by limit and round up to integer (example: 5/2 = 3)
      var last = count ~/ limit;

      return ChatListModel(
        chats: chats,
        page: page,
        limit: limit,
        last: last,
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

  // see chat
  Future<void> see({required String chatId}) async {
    log('[chat.service.dart] see all $chatId');
    ApiService.socket.send(
      event: CHAT_EVENTS.SEE_MESSAGE,
      data: {
        'method': 'all',
        'chat_id': chatId,
      },
    );
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

  void action({required String type}) {
    return;
    var chatId = Services.configs.get(key: CONSTANTS.CURRENT_CHAT);

    if (chatId == null) {
      return;
    }

    log('[chat.service.dart] action $type');

    ApiService.socket.send(
      event: CHAT_EVENTS.ACTION_EVENT,
      data: {
        'action': type,
        'chat_id': chatId,
      },
    );
  }
}
