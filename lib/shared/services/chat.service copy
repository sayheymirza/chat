import 'dart:developer';
import 'dart:io';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatService extends GetxService {
  RxInt unreadedChats = 0.obs;
  RxInt unreadedMessages = 0.obs;

  RxString selectedChat = "".obs;

  @override
  void onInit() {
    super.onInit();

    // listen to messages
    listen();

    event.on<EventModel>().listen((data) async {
      if (data.event == CHAT_EVENTS.RECIVE_MESSAGE) {
        var value = data.value as ChatMessageModel;

        try {
          MessageTableData? message;

          if (value.localId != "-1") {
            // update message with local id
            var queryMessage = database.select(database.messageTable)
              ..where((item) => item.local_id.equals(value.localId!));

            message = await queryMessage.getSingleOrNull();
          }

          if (message != null) {
            // update
            log('[chat.service.dart] updating message with local id ${value.localId} and chat id ${value.chatId}');
            database.update(database.messageTable)
              ..where((item) => item.local_id.equals(value.localId!))
              ..write(
                MessageTableCompanion(
                  id: drift.Value(value.id),
                  local_id: drift.Value(value.localId),
                  chat_id: drift.Value(value.chatId),
                  status: drift.Value(value.status),
                  sender_id: drift.Value(value.senderId),
                  sent_at: drift.Value(value.sentAt),
                  type: drift.Value(value.type),
                  data: drift.Value(value.data),
                  meta: drift.Value(value.meta),
                ),
              );
          } else {
            // create
            log('[chat.service.dart] creating message with local id ${value.localId} and chat id ${value.chatId}');

            await database.into(database.messageTable).insert(
                  MessageTableCompanion(
                    id: drift.Value(value.id),
                    local_id: drift.Value(value.localId),
                    chat_id: drift.Value(value.chatId),
                    status: drift.Value(value.status),
                    sender_id: drift.Value(value.senderId),
                    sent_at: drift.Value(value.sentAt),
                    type: drift.Value(value.type),
                    data: drift.Value(value.data),
                    meta: drift.Value(value.meta),
                  ),
                );

            await database.transaction(() async {
              // check chat id exists
              var querySelect = database.select(database.chatTable)
                ..where((row) => row.id.equals(value.chatId));

              if (await querySelect.getSingleOrNull() == null) {
                // create the chat
              }
            });
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Future<String?> openChat({required String userId}) async {
    try {
      log('[chats.controller.dart] open chat $userId');
      // 1. find chat from paricipents
      var query = database.select(database.chatParticipantTable);

      query.where((row) => row.user_id.equals(userId));
      try {
        var resultOfChat = await query.get();

        // 2. if chat exists
        if (resultOfChat != null || resultOfChat.isNotEmpty) {
          return resultOfChat.first.chat_id;
        }
      } catch (e) {
        //
      }

      // 3. create new chat
      var resultOfCreate = await ApiService.chat.createWithUserId(
        userId: userId,
      );

      // 4. save new chat
      if (resultOfCreate != null) {
        await database.transaction(() async {
          // create the chat
          await database.into(database.chatTable).insert(
                ChatTableCompanion.insert(
                  id: resultOfCreate.chatId,
                  permissions: resultOfCreate.permissions,
                ),
              );
          // create participant with chat
          await database.into(database.chatParticipantTable).insert(
                ChatParticipantTableCompanion.insert(
                  user_id: userId.toString(),
                  chat_id: resultOfCreate.chatId,
                ),
              );
        });

        return resultOfCreate.chatId;
      }

      return null;
    } catch (e) {
      print(e);

      return null;
    }
  }

  Future<String?> getUserIdFromChatId({required String id}) async {
    try {
      var queryParticipant = database.select(database.chatParticipantTable);
      queryParticipant.where((value) => value.chat_id.equals(id));
      var resultParticipant = await queryParticipant.getSingleOrNull();

      if (resultParticipant == null) {
        return null;
      }

      return resultParticipant.user_id;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteMessage({
    required String messageId,
  }) async {
    log('[chats.service.dart] delete message with id $messageId');

    try {
      // remove from database
      await database.transaction(() async {
        var query = database.update(database.messageTable);
        query.where((row) => row.id.equals(messageId));
        await query.write(
          MessageTableCompanion(status: drift.Value('deleted')),
        );
      });
    } catch (e) {
      //
    }
  }

  Future<void> cancelMessage({
    required String localId,
  }) async {
    log('[chats.service.dart] cancel message with local id $localId');

    try {
      // remove from database
      await database.transaction(() async {
        var query = database.delete(database.messageTable);
        query.where((row) => row.local_id.equals(localId));
        query.where((row) => row.status.equals('sent').not());
        await query.goAndReturn();
      });
    } catch (e) {
      //
    }
  }

  Future<void> deleteChat({
    required String chatId,
  }) async {
    log('[chats.service.dart] delete chat with id $chatId');

    try {
      // delete all messages, chat, participant
      await database.transaction(() async {
        await (database.delete(database.messageTable)
              ..where((value) => value.chat_id.equals(chatId)))
            .go();
        await (database.delete(database.chatTable)
              ..where((value) => value.id.equals(chatId)))
            .go();
        await (database.delete(database.chatParticipantTable)
              ..where((value) => value.chat_id.equals(chatId)))
            .go();
      });
    } catch (e) {
      //
    }
  }

  Future<void> save({
    required ChatMessageModel message,
  }) async {
    var id = Uuid().v4().toString();
    message.chatId = selectedChat.value.toString();
    message.localId = id;
    message.senderId = Services.profile.profile.value.id ?? '-1';

    log('[chat.service.dart] save message with local id $id and chat id ${message.chatId}');

    try {
      // save on database
      await database.transaction(
        () async {
          await database.into(database.messageTable).insert(
                MessageTableCompanion.insert(
                  local_id: drift.Value(message.localId),
                  chat_id: message.chatId,
                  sender_id: message.senderId,
                  sent_at: drift.Value(message.sentAt),
                  type: message.type,
                  data: message.toData(),
                  status: message.status,
                  meta: {},
                ),
              );
        },
      );
    } catch (e) {
      //
    }
  }

  void send({
    required ChatMessageModel message,
  }) {
    if (message.status != "sending") return;
    log('[chat.service.dart] send message with local id ${message.localId} and chat id ${message.chatId}');

    ApiService.socket.send(
      event: CHAT_EVENTS.SEND_MESSAGE,
      data: message,
    );
  }

  Future<void> sendByLocalId({
    required String localId,
  }) async {
    try {
      database.update(database.messageTable)
        ..where((item) => item.local_id.equals(localId))
        ..write(
          MessageTableCompanion(
            status: drift.Value("unknown"),
          ),
        );
    } catch (e) {
      //
    }
  }

  Future<void> clear() async {
    try {
      var chats = await database.delete(database.chatTable).go();
      var participants =
          await database.delete(database.chatParticipantTable).go();
      var messages = await database.delete(database.messageTable).go();

      log('[user.service.dart] clear $chats chats and $participants participants and $messages messages');
    } catch (e) {
      //
    }
  }

  void upload({
    required String localId,
    required File file,
    required ChatMessageModel Function(String url, String fileId) onUploaded,
    String category = "file",
  }) {
    Services.queue.add(() async {
      try {
        database.update(database.messageTable)
          ..where((item) => item.local_id.equals(localId))
          ..write(
            MessageTableCompanion(
              status: drift.Value("uploading"),
              meta: drift.Value({
                'percent': 0,
                'total': file.statSync().size,
                'sent': 0,
              }),
            ),
          );

        // start uploading
        var result = await Services.file.upload(
            file: file,
            category: category,
            onUploading: ({int percent = 0, int total = 0, int sent = 0}) {
              database.update(database.messageTable)
                ..where((item) => item.local_id.equals(localId))
                ..write(
                  MessageTableCompanion(
                    status: drift.Value("uploading"),
                    meta: drift.Value({
                      'percent': percent,
                      'total': total,
                      'sent': sent,
                    }),
                  ),
                );
            });

        if (result != null && result.done) {
          var message = onUploaded(result.url!, result.fileId!);

          // save the message
          database.update(database.messageTable)
            ..where((item) => item.local_id.equals(localId))
            ..write(
              MessageTableCompanion(
                data: drift.Value(message.data),
                status: drift.Value("sending"),
                meta: drift.Value({
                  'percent': result.percent,
                  'total': result.total,
                  'sent': result.sentOrRecived,
                }),
              ),
            );
        } else {
          database.update(database.messageTable)
            ..where((item) => item.local_id.equals(localId))
            ..write(
              MessageTableCompanion(
                status: drift.Value("unuploaded"),
              ),
            );
        }
      } catch (e) {
        log("[chat.service.dart] upload exeption:");
        print(e);
        print("");

        database.update(database.messageTable)
          ..where((item) => item.local_id.equals(localId))
          ..write(
            MessageTableCompanion(
              status: drift.Value("unuploaded"),
            ),
          );
      }
    });
  }

  void listen() {
    database.select(database.messageTable)
      ..where((value) => value.status.equals('sending'))
      ..watch().listen(
        (value) {
          for (var data in value) {
            var message = ChatMessageModel.fromDatabase(data);

            // sent the message
            send(message: message);
          }
        },
      );

    database.select(database.messageTable)
      ..where((value) => value.status.equals('unknown'))
      ..watch().listen(
        (value) {
          for (var data in value) {
            var message = ChatMessageModel.fromDatabase(data);

            // check file is in message
            if (message.fileUrl != null) {
              if (!message.fileUrl!.startsWith('http')) {
                upload(
                  localId: message.localId!,
                  file: message.file!,
                  onUploaded: (String url, String fileId) {
                    message.fileUrl = url;
                    message.fileId = fileId;

                    return message;
                  },
                );
              } else if (message.fileUrl!.startsWith('http')) {
                database.update(database.messageTable)
                  ..where((item) => item.local_id.equals(message.localId!))
                  ..write(
                    MessageTableCompanion(
                      status: drift.Value("sending"),
                    ),
                  );
              }
            }
          }
        },
      );
  }
}
