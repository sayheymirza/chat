import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MessageService extends GetxService {
  // listen to events
  void listenToEvents() {
    event.on<EventModel>().listen((data) async {
      if (data.event == CHAT_EVENTS.RECIVE_MESSAGE) {
        var value = data.value as ChatMessageModel;

        onReciveMessage(message: value);
      }
    });
  }

  void onReciveMessage({required ChatMessageModel message}) async {
    try {
      // 1. check local id exists to update that
      if (message.localId != null && message.localId != '-1') {
        // update message with that local id
        // if it doesn't update means local id not exists
        if (await update(message: message)) {
          log('[message.service.dart] recive message and updated with local id ${message.localId} and chat id ${message.chatId}');
          return;
        }
      }

      // 2. create the message
      log('[message.service.dart] recive message and created with local id ${message.localId} and chat id ${message.chatId}');
      await database.into(database.messageTable).insert(
            MessageTableCompanion(
              message_id: drift.Value(message.messageId),
              local_id: drift.Value(message.localId),
              chat_id: drift.Value(message.chatId!),
              status: drift.Value(message.status ?? 'unknown'),
              sender_id: drift.Value(message.senderId!),
              sent_at: drift.Value(message.sentAt!),
              type: drift.Value(message.type!),
              data: drift.Value(message.data),
              meta: drift.Value(message.meta),
              seq: drift.Value(message.seq ?? 0),
            ),
          );
    } catch (e) {
      //
    }
  }

  // stream message (chat_id and limit)
  Stream<List<MessageTableData>> stream({
    required String chatId,
    int limit = 20,
  }) {
    log('[message.service.dart] stream messages for chat id $chatId');

    var query = database.select(database.messageTable);

    query.where((row) => row.chat_id.equals(chatId));

    query.orderBy([
      (row) => drift.OrderingTerm(
            expression: row.seq,
            mode: drift.OrderingMode.asc,
          ),
    ]);

    query.limit(limit);

    return query.watch();
  }

  // select message (sent_at and limit)
  void select({
    required String chatId,
    required DateTime sentAt,
    int limit = 20,
  }) {}

  // save message
  Future<void> save({required ChatMessageModel message}) async {
    // add some data to model
    var id = Uuid().v4().toString();
    var chat_id = Services.configs.get(key: CONSTANTS.CURRENT_CHAT);

    message.localId = id;
    message.chatId = chat_id;
    message.senderId = Services.profile.profile.value.id ?? '-1';
    message.sentAt = DateTime.now();
    message.seq = DateTime.now().millisecondsSinceEpoch;

    log('[message.service.dart] save message with local id ${message.localId} and chat id ${message.chatId}');

    try {
      await database.into(database.messageTable).insert(
            MessageTableCompanion.insert(
              local_id: drift.Value(message.localId),
              chat_id: message.chatId!,
              sender_id: message.senderId!,
              type: message.type!,
              data: message.toData(),
              meta: message.meta ?? {},
            ),
          );
    } catch (e) {
      print(e.toString());
    }
  }

  // send message (from model)
  void send({required ChatMessageModel message}) {
    try {
      // update message to sending and send it to socket
      message.status = "sending";
      update(message: message);
      ApiService.socket.send(event: CHAT_EVENTS.SEND_MESSAGE, data: message);
    } catch (e) {
      //
    }
  }

  // send message by local_id (select from database and send)
  void sendByLocalId({required String localId}) async {
    try {
      var message = await (database.select(database.messageTable)
            ..where((row) => row.local_id.equals(localId)))
          .getSingleOrNull();

      if (message != null) {
        send(message: ChatMessageModel.fromDatabase(message));
      }
    } catch (e) {
      //
    }
  }

  // update message (from model to database)
  Future<bool> update({required ChatMessageModel message}) async {
    try {
      log('[message.service.dart] update message with localId ${message.localId}');
      var result = await (database.update(database.messageTable)
            ..where((item) => item.local_id.equals(message.localId!)))
          .write(
        MessageTableCompanion(
          message_id: drift.Value(message.messageId),
          local_id: drift.Value(message.localId),
          chat_id: drift.Value(message.chatId!),
          status: drift.Value(message.status ?? 'unknown'),
          sender_id: drift.Value(message.senderId!),
          sent_at: drift.Value(message.sentAt!),
          type: drift.Value(message.type!),
          data: drift.Value(message.data),
          meta: drift.Value(message.meta),
          seq: drift.Value(message.seq ?? 0),
        ),
      );

      return result != 0;
    } catch (error) {
      return false;
    }
  }

  // upload message (callback)
  // delete message by local_id
  void deleteByLocalId({required String localId}) {
    log('[message.service.dart] delete message with local id $localId');

    try {
      (database.update(database.messageTable)
            ..where((row) => row.local_id.equals(localId)))
          .write(MessageTableCompanion(status: drift.Value("deleted")));
    } catch (e) {
      //
    }
  }

  // delete message by message_id
  void deleteByMessageId({required String messageId, bool forAll = false}) {
    log('[message.service.dart] delete message with message id $messageId');

    try {
      (database.update(database.messageTable)
            ..where((row) => row.message_id.equals(messageId)))
          .write(MessageTableCompanion(status: drift.Value("deleted")));
    } catch (e) {
      //
    }
  }

  // delete message by chat_id
  Future<void> deleteByChatId({required String chatId}) async {
    try {
      var count = await (database.delete(database.messageTable)
            ..where((row) => row.chat_id.equals(chatId)))
          .go();

      log('[message.service.dart] clear over $count messages for chat id $chatId');
    } catch (e) {
      //
    }
  }

  // clear (clear all messages)
  Future<void> clear() async {
    try {
      var count = await database.delete(database.messageTable).go();
      log('[message.service.dart] clear over $count messages');
    } catch (e) {
      //
    }
  }
}
