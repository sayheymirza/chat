import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MessageService extends GetxService {
  bool isCurrentChat(String chatId) {
    var chat_id = Services.configs.get(key: CONSTANTS.CURRENT_CHAT);

    return chat_id == chatId;
  }

  Future<ChatMessageModel?> lastByChatId({required String chatId}) async {
    try {
      var last = await (database.select(database.messageTable)
            ..where((row) =>
                row.chat_id.equals(chatId) &
                (row.status.equals('sent') | row.status.equals('seen')))
            ..limit(1)
            ..orderBy([
              (row) => drift.OrderingTerm(
                    expression: row.sent_at,
                    mode: drift.OrderingMode.desc,
                  ),
            ]))
          .getSingleOrNull();

      if (last != null) {
        return ChatMessageModel.fromDatabase(last);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // sync api with database
  Future<List<MessageTableData>> syncAPIWithDatabase({
    required String chatId,
    double? seq,
    ApiChatMessageOperator operator = ApiChatMessageOperator.BEFORE,
    CancelToken? cancelToken,
    int limit = 100,
    int page = 1,
  }) async {
    try {
      var result = await ApiService.chat.messages(
        chatId: chatId,
        page: page,
        limit: limit,
        operator: operator,
        seq: seq,
        cancelToken: cancelToken,
      );

      if (cancelToken != null && cancelToken.isCancelled) {
        return [];
      }

      if (result.messages.isEmpty) {
        log('[message.service.dart] syncing api with database for chat id $chatId at seq $seq ${operator.toString().split('.').last.toLowerCase()} got 0 messages');
        return [];
      }

      log('[message.service.dart] syncing api with database for chat id $chatId at seq $seq ${operator.toString().split('.').last.toLowerCase()} got ${result.messages.length} messages');

      var datas = <MessageTableData>[];

      for (var message in result.messages) {
        var data = MessageTableCompanion(
          message_id: drift.Value(message.messageId!),
          local_id: drift.Value(message.localId!),
          chat_id: drift.Value(message.chatId!),
          status: drift.Value(message.status!),
          sender_id: drift.Value(message.senderId!),
          sent_at: drift.Value(message.sentAt!),
          type: drift.Value(message.type!),
          data: drift.Value(message.data!),
          meta: drift.Value(message.meta!),
          theme: drift.Value(message.theme!),
          seq: drift.Value(double.parse(message.seq.toString())),
        );

        await database.transaction(() async {
          // 1. find one
          var one = await (database.select(database.messageTable)
                ..where((row) =>
                    row.message_id.equals(message.messageId!) |
                    row.local_id.equals(message.localId!)))
              .getSingleOrNull();
          // 2. create
          if (one == null) {
            var result = await database
                .into(database.messageTable)
                .insertReturningOrNull(data);

            if (result != null) {
              datas.add(result);
            }
          }
          // 3. update
          else {
            var result = await (database.update(database.messageTable)
                  ..where((row) => row.id.equals(one.id)))
                .writeReturning(data);

            if (result.isNotEmpty) {
              datas.add(result.first);
            }
          }
        });
      }

      return datas;
    } catch (e) {
      print('error on sync api with database');
      print(e);

      return [];
    }
  }

  // listen to events
  void listenToEvents() {
    event.on<EventModel>().listen((data) async {
      if (data.event == CHAT_EVENTS.ON_RECEIVE_MESSAGE) {
        var value = data.value as ChatMessageModel;

        onReciveMessage(message: value);
      }

      if (data.event == CHAT_EVENTS.DELETE_CHAT) {
        var value = data.value as String;

        // delete messages by chat_id (forever)
        deleteByChatId(chatId: value);
      }

      if (data.event == CHAT_EVENTS.ON_DELETE_MESSAGE) {
        var id = data.value['message_id'];

        // delete message by message_id
        deleteByMessageId(messageId: id);
      }

      if (data.event == CHAT_EVENTS.ON_SEE_MESSAGE) {
        var id = data.value['message_id'];

        // seen message by message_id
        seen(messageId: id);
      }
    });
  }

  void onReciveMessage({required ChatMessageModel message}) async {
    try {
      // 0. see message if sender_id not equal to current user id and chat_id is current chat
      var userId = Services.profile.profile.value.id;
      var chatId = Services.configs.get(key: CONSTANTS.CURRENT_CHAT);

      try {
        if (message.messageId != null &&
            userId != null &&
            chatId == message.chatId &&
            message.senderId != userId) {
          seen(messageId: message.messageId!);
          see(messageId: message.messageId!);
        }
      } catch (e) {
        //
      }

      // 1. check local id exists to update that
      if (message.localId != null && message.localId != '-1') {
        // update message with that local id
        // if it doesn't update means local id not exists
        var updated = await update(message: message);

        if (updated == true) {
          log('[message.service.dart] receive message and updated with local id ${message.localId} and chat id ${message.chatId}');
          return;
        }
      }

      // 2. create the message
      log('[message.service.dart] receive message and created with local id ${message.localId} and chat id ${message.chatId}');
      var data = await database.into(database.messageTable).insertReturning(
            MessageTableCompanion(
              message_id: drift.Value(message.messageId),
              local_id: drift.Value(message.localId),
              chat_id: drift.Value(message.chatId!),
              status: drift.Value(message.status ?? 'unknown'),
              sender_id: drift.Value(message.senderId!),
              sent_at: drift.Value(message.sentAt!),
              type: drift.Value(message.type!),
              data: drift.Value(message.toData()),
              meta: drift.Value(message.meta ?? {}),
              theme: drift.Value(message.theme ?? {}),
              seq: drift.Value(message.seq ?? 0),
              reaction: drift.Value(message.reaction),
            ),
          );

      if (isCurrentChat(message.chatId!)) {
        Services.event.fire(
          event: MESSAGE_EVENTS.ADD_MESSAGE,
          value: data,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // listen to chat_id to send message when status is sending
  StreamSubscription<List<MessageTableData>> listenToSending({
    required String chatId,
  }) {
    log('[message.service.dart] sending messages for chat id $chatId');

    var query = database.select(database.messageTable);

    query.where(
      (row) => row.chat_id.equals(chatId) & row.status.equals('sending'),
    );

    // limit to 1
    query.limit(1);

    var watcher = query.watch();

    return watcher.listen((data) {
      for (var item in data) {
        log('[message.service.dart] sending message for chat id $chatId and local_id ${item.local_id}');
        send(message: ChatMessageModel.fromDatabase(item));
      }
    });
  }

  // stream message (chat_id and limit)
  Stream<List<MessageTableData>> stream({
    required String chatId,
    int limit = 20,
  }) {
    log('[message.service.dart] stream messages for chat id $chatId');

    var query = database.select(database.messageTable);

    // limit
    if (limit != 0) {
      query.limit(limit);
    }

    // order by sent_at new to old
    query.orderBy([
      (row) => drift.OrderingTerm(
            expression: row.seq,
            mode: limit == 0 ? drift.OrderingMode.asc : drift.OrderingMode.desc,
          ),
    ]);

    query.where((row) => row.chat_id.equals(chatId));

    return query.watch();
  }

  // select message (sent_at and limit)
  Future<List<MessageTableData>> select({
    required String chatId,
    double? seq,
    ApiChatMessageOperator operator = ApiChatMessageOperator.BEFORE,
    int limit = 20,
    int page = 1,
  }) async {
    log('[message.service.dart] select messages for chat id $chatId at seq $seq ${operator.toString().split('.').last.toLowerCase()}');

    try {
      var query = database.select(database.messageTable);

      query.where((row) => row.chat_id.equals(chatId));

      if (seq != null) {
        query.where((row) => operator == ApiChatMessageOperator.BEFORE
            ? row.seq.isSmallerThanValue(seq)
            : row.seq.isBiggerThanValue(seq));
      }

      // limit and page
      query.limit(limit, offset: (page - 1) * limit);

      query.orderBy([
        (row) => drift.OrderingTerm(
              expression: row.seq,
              mode: drift.OrderingMode.desc,
            ),
      ]);

      var messages = await query.get();

      return messages;
    } catch (e) {
      return [];
    }
  }

  // save message
  Future<void> save({required ChatMessageModel message}) async {
    // add some data to model
    var id = Uuid().v4().toString();
    var chat_id = Services.configs.get(key: CONSTANTS.CURRENT_CHAT);

    // get one last message from chat id
    var last = await (database.select(database.messageTable)
          ..where((row) => row.chat_id.equals(chat_id))
          ..orderBy([
            (row) => drift.OrderingTerm(
                  expression: row.seq,
                  mode: drift.OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();

    message.localId = id;
    message.chatId = chat_id;
    message.senderId = Services.profile.profile.value.id ?? '-1';
    message.sentAt = DateTime.now();
    message.seq = (last?.seq ?? 0) + 0.0001;

    log('[message.service.dart] save message with local id ${message.localId} and chat id ${message.chatId} and seq ${message.seq}');

    try {
      var data = await database.into(database.messageTable).insertReturning(
            MessageTableCompanion.insert(
              local_id: drift.Value(message.localId),
              chat_id: message.chatId!,
              sender_id: message.senderId!,
              sent_at: drift.Value(message.sentAt!),
              type: message.type!,
              data: message.toData(),
              meta: message.meta ?? {},
              theme: message.theme ?? {},
              seq: drift.Value(message.seq ?? 0),
            ),
          );

      Services.event.fire(
        event: MESSAGE_EVENTS.ADD_MESSAGE,
        value: data,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // send message (from model)
  void send({required ChatMessageModel message}) {
    try {
      if (message.status == "sending") {
        ApiService.socket.send(event: CHAT_EVENTS.SEND_MESSAGE, data: message);
      }
    } catch (e) {
      //
    }
  }

  // see message
  void see({required String messageId}) {
    log('[message.service.dart] see message with message id $messageId');
    ApiService.socket.send(
      event: CHAT_EVENTS.SEE_MESSAGE,
      data: {'message_id': messageId, 'method': 'one'},
    );
  }

  // seen message (update status to seen)
  void seen({required String messageId}) async {
    try {
      log('[message.service.dart] seen message with message id $messageId');
      var result = await (database.update(database.messageTable)
            ..where((row) => row.message_id.equals(messageId)))
          .writeReturning(MessageTableCompanion(status: drift.Value("seen")));

      if (result.isNotEmpty) {
        Services.event.fire(
          event: MESSAGE_EVENTS.UPDATE_MESSAGE,
          value: result.first,
        );
      }
    } catch (e) {
      print(e);
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
          .writeReturning(
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

      if (result.length == 1 && isCurrentChat(message.chatId!)) {
        Services.event.fire(
          event: MESSAGE_EVENTS.UPDATE_MESSAGE,
          value: result.first,
        );
      }

      return result.isNotEmpty;
    } catch (error) {
      print('[message.service.dart] error on update message');
      print(error);
      return false;
    }
  }

  // upload message (callback)
  // delete message by local_id
  void deleteByLocalId({required String localId}) async {
    log('[message.service.dart] delete message with local id $localId');

    try {
      var result = await (database.delete(database.messageTable)
            ..where((row) => row.local_id.equals(localId)))
          .goAndReturn();

      if (result.length == 1 && isCurrentChat(result.first.chat_id)) {
        Services.event.fire(
          event: MESSAGE_EVENTS.DELETE_LOCAL_MESSAGE,
          value: localId,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // delete message by message_id
  void deleteByMessageId({
    required String messageId,
    bool forAll = false,
  }) async {
    log('[message.service.dart] delete message with message id $messageId');

    try {
      var result = await (database.update(database.messageTable)
            ..where((row) => row.message_id.equals(messageId)))
          .writeReturning(
        MessageTableCompanion(status: drift.Value("deleted")),
      );

      if (result.length == 1 && isCurrentChat(result.first.chat_id)) {
        Services.event.fire(
          event: MESSAGE_EVENTS.UPDATE_MESSAGE,
          value: result.first,
        );
      }

      ApiService.socket.send(
        event: CHAT_EVENTS.DELETE_MESSAGE,
        data: {
          'message_id': messageId,
          'all': forAll,
        },
      );
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
      print(e);
    }
  }

  Future<void> sendAll() async {
    try {
      var messages = await (database.select(database.messageTable)
            ..where((row) => row.status.equals('sending')))
          .get();

      log('[message.service.dart] send all messages with length ${messages.length}');

      for (var message in messages) {
        send(message: ChatMessageModel.fromDatabase(message));
      }
    } catch (e) {
      //
    }
  }
}
