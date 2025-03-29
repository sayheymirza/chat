import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/socket.model.dart';
import 'package:chat/models/chat/admin.model.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class AdminChatService extends GetxService {
  // sync api with database
  Future<void> syncAPIWithDatabase() async {
    try {
      var lastSyncDate = await Services.sync.get(category: 'admin-chat');

      var page = 1;

      do {
        var result = await ApiService.admin.list(
          page: page,
          limit: 20,
          syncDate: lastSyncDate,
        );

        log('[chat.service.dart] syncing api with database on page $page got ${result.chats.length} admins');

        for (var chat in result.chats) {
          var data = AdminChatTableCompanion(
            chat_id: drift.Value(chat.chatId!),
            title: drift.Value(chat.title!),
            subtitle: drift.Value(chat.subtitle!),
            image: drift.Value(chat.image!),
            message: drift.Value(
              chat.message?.toJson() ?? {},
            ),
            status: drift.Value('normal'),
            unread_count: drift.Value(chat.unreadCount!),
            updated_at: drift.Value(chat.updatedAt!),
          );

          await database.transaction(() async {
            // 1. find one
            var one = await (database.select(database.adminChatTable)
                  ..where((row) => row.chat_id.equals(chat.chatId!)))
                .getSingleOrNull();
            // 2. create
            if (one == null) {
              await database.into(database.adminChatTable).insert(data);
            }
            // 3. update
            else {
              await (database.update(database.adminChatTable)
                    ..where((row) => row.chat_id.equals(chat.chatId!)))
                  .write(data);
            }
          });
        }

        if (result.last <= page || result.last == 0) {
          // save new last sync date
          await Services.sync.set(
            category: 'admin-chat',
            syncedAt: DateTime.now(),
          );

          log('[admin-chat.service.dart] sync done');

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

      if (data.event == CHAT_EVENTS.ON_RECEIVE_ADMIN_MESSAGE) {
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
      var chat = await (database.select(database.adminChatTable)
            ..where((row) => row.chat_id.equals(message.chatId!)))
          .getSingleOrNull();

      if (chat != null) {
        // update last message
        updateLastMessage(chatId: message.chatId!);
      }
    } catch (e) {
      //
    }
  }

  // update last message
  Future<void> updateLastMessage({required String chatId}) async {
    try {
      // 1. get last message that exists
      var last = await (database.select(database.messageTable)
            ..where((row) => row.chat_id.equals(chatId))
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

        await (database.update(database.adminChatTable)
              ..where((row) => row.chat_id.equals(chatId)))
            .write(AdminChatTableCompanion(
          message: drift.Value(message.toJson()),
          updated_at: drift.Value(DateTime.now()),
        ));
      }
    } catch (e) {
      //
    }
  }

  // get chat by chat id and create if not exists else update it
  Future<bool> one({required String chatId}) async {
    try {
      var result = await ApiService.admin.one(chatId: chatId);

      if (result != null) {
        await database.transaction(() async {
          // 1. find one
          var one = await (database.select(database.adminChatTable)
                ..where((row) => row.chat_id.equals(chatId)))
              .getSingleOrNull();
          // 2. create
          if (one == null) {
            await database.into(database.adminChatTable).insert(
                  AdminChatTableCompanion.insert(
                    chat_id: chatId,
                    title: result.title,
                    subtitle: result.subtitle,
                    image: result.image,
                    message: drift.Value({}),
                    permissions: drift.Value(result.permissions),
                    unread_count: drift.Value(result.unread_count),
                    updated_at: result.updated_at,
                  ),
                );
          }
          // 3. update
          else {
            await (database.update(database.adminChatTable)
                  ..where((row) => row.chat_id.equals(chatId)))
                .write(
              AdminChatTableCompanion(
                title: drift.Value(result.title),
                subtitle: drift.Value(result.subtitle),
                image: drift.Value(result.image),
                permissions: drift.Value(result.permissions),
                unread_count: drift.Value(result.unread_count),
                updated_at: drift.Value(result.updated_at),
              ),
            );
          }
        });

        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // listen to unreaded chats
  Stream<int> listenToUnreadedChats() {
    return (database.selectOnly(database.adminChatTable)
          ..addColumns([database.adminChatTable.unread_count.sum()]))
        .map((row) => row.read(database.adminChatTable.unread_count.sum()) ?? 0)
        .watchSingle();
  }

  // get chat by chat id
  Future<Stream<AdminModel?>> stream({required String chatId}) async {
    log('[chat.service.dart] stream chat with chat id $chatId');

    try {
      var query = database.select(database.adminChatTable)
        ..where((row) => row.chat_id.equals(chatId));

      return query.map((row) {
        return AdminModel.fromJson({
          "chat_id": row.chat_id,
          "title": row.title,
          'subtitle': row.subtitle,
          "image": row.image,
          "message": row.message,
          "permissions": row.permissions,
          "status": row.status,
          "unread_count": row.unread_count,
          "updated_at": row.updated_at,
        });
      }).watchSingleOrNull();
    } catch (e) {
      return Stream.value(null);
    }
  }

  // select chats (limit and sort by updated_at and join to last message) steam
  Future<Stream<AdminListModel>> list({int page = 1, int limit = 6}) async {
    try {
      var query = database.select(database.adminChatTable);

      query.orderBy(
        [
          (row) => drift.OrderingTerm(
                expression: row.updated_at,
                mode: drift.OrderingMode.desc,
              ),
        ],
      );

      query.limit(limit, offset: (page - 1) * limit);

      var count = await database.adminChatTable.count().getSingle();

      return query
          .map((row) {
            return AdminModel.fromJson({
              "chat_id": row.chat_id,
              "title": row.title,
              "image": row.image,
              "message": row.message,
              "permissions": row.permissions,
              "status": row.status,
              "unread_count": row.unread_count,
              "updated_at": row.updated_at,
            });
          })
          .watch()
          .map(
            (chats) {
              var last = (count / limit).ceil();

              return AdminListModel(
                chats: chats,
                page: page,
                limit: limit,
                last: last,
                total: count,
              );
            },
          );
    } catch (e) {
      return Stream.value(AdminListModel(
        page: page,
        limit: limit,
      ));
    }
  }

  // delete chat
  Future<bool> delete({required String chatId}) async {
    try {
      await (database.delete(database.adminChatTable)
            ..where((row) => row.chat_id.equals(chatId)))
          .go();
      return true;
    } catch (e) {
      return false;
    }
  }

  // select chats (limit and sort by updated_at and join to last message)
  Future<AdminListModel> select({int page = 1, int limit = 6}) async {
    try {
      var query = database.select(database.adminChatTable);

      query.orderBy(
        [
          (row) => drift.OrderingTerm(
                expression: row.updated_at,
                mode: drift.OrderingMode.desc,
              ),
        ],
      );

      query.limit(limit, offset: (page - 1) * limit);

      var chats = await query.map((row) {
        return AdminModel.fromJson({
          "chat_id": row.chat_id,
          "title": row.title,
          "image": row.image,
          "message": row.message,
          "permissions": row.permissions,
          "status": row.status,
          "unread_count": row.unread_count,
          "updated_at": row.updated_at,
        });
      }).get();

      var count = await database.adminChatTable.count().getSingle();

      return AdminListModel(
        chats: chats,
        page: page,
        limit: limit,
        last: (count / limit).ceil(),
        total: count,
      );
    } catch (e) {
      print(e.toString());

      return AdminListModel(
        page: page,
        limit: limit,
      );
    }
  }

  // clear (clear all chats)
  Future<void> clear() async {
    try {
      var count = await database.delete(database.adminChatTable).go();
      log('[admin-chat.service.dart] clear over $count admin chats');
    } catch (e) {
      //
    }
  }
}
