import 'dart:convert';
import 'dart:developer';

import 'package:chat/abstracts/apis/socket.abstract.dart';
import 'package:chat/models/apis/socket.model.dart';
import 'package:chat/models/chat/chat.event.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/services/file.service.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends SocketAbstract {
  IO.Socket? socket;
  RxString status = "connecting".obs;

  @override
  void connect() {
    if (socket != null) return;

    var accessToken = Services.configs.get(
      key: CONSTANTS.STORAGE_ACCESS_TOKEN,
    );

    var endpoint = Services.configs.get(key: CONSTANTS.STORAGE_ENDPOINT_API);

    if (endpoint == null || endpoint.isEmpty) {
      // use default
      endpoint = CONSTANTS.DEFAULT_ENDPOINT_API;
    }

    log('[socket.service.dart] socket is connecting to $endpoint with access token $accessToken');

    status.value = "connecting";

    socket = IO.io(
      endpoint,
      IO.OptionBuilder().setTransports(['websocket']).setQuery({
        'token': accessToken,
        'flavor': CONSTANTS.FLAVOR,
      }).build(),
    );
  }

  @override
  void disconnect() {
    if (socket != null) {
      log('[socket.service.dart] socket disconnect');
      status.value = "disconnect";
      socket!.disconnect();
      socket!.close();
      socket!.destroy();
      socket!.dispose();

      // remove listen event
      socket!.offAny((event, data) {});

      socket = null;
    }
  }

  @override
  void listen() {
    if (socket == null) return;

    socket!.onError((error) {
      status.value = "errored";
      log('[socket.service.dart] socket errored');
      Services.log.add(category: 'socket', message: 'connection errored');
      Services.event.fire(event: SOCKET_EVENTS.DISCONNECTED);
      print(error);
    });

    socket!.onConnect((_) {
      status.value = "connected";
      log('[socket.service.dart] socket connected');
      Services.log.add(category: 'socket', message: 'connected');
      Services.event.fire(event: SOCKET_EVENTS.CONNECTED);
    });

    socket!.onDisconnect((_) {
      status.value = "disconnect";
      log('[socket.service.dart] socket disconnected');
      Services.log.add(category: 'socket', message: 'disconnected');
      Services.event.fire(event: SOCKET_EVENTS.DISCONNECTED);
    });

    socket!.onReconnect((_) {
      status.value = "reconnecting";
      log('[socket.service.dart] socket reconnecting');
      Services.log.add(category: 'socket', message: 'reconnecting');
      Services.event.fire(event: SOCKET_EVENTS.RECONNECTING);
    });

    socket!.onReconnectFailed((_) {
      status.value = "error";
      log('[socket.service.dart] socket reconnect failed');
      Services.log.add(category: 'socket', message: 'reconnect failed');
      Services.event.fire(event: SOCKET_EVENTS.DISCONNECTED);
    });

    socket!.onAny((event, data) {
      if (data == null) {
        return;
      }

      Services.log.add(
        category: 'socket',
        message: jsonEncode({'type': 'received', 'event': event, 'data': data}),
      );

      log('[socket.service.dart] socket receive $event');

      onListen(event: event, data: data);
    });
  }

  @override
  void emit({required String event, required data}) {
    if (socket == null) return;

    log('[socket.service.dart] socket emit $event');

    Services.log.add(
      category: 'socket',
      message: jsonEncode({
        'connection': status.value,
        'type': 'emitted',
        'event': event,
        'data': data,
      }),
    );

    socket!.emit(event, data);
  }

  @override
  void send({required String event, required data}) {
    log('[socket.service.dart] socket emit $event');

    if (event == SOCKET_EVENTS.SOCKET_REQUEST) {
      if (data['request_id'] == null) {
        data['request_id'] = uuid().toString();
      }

      return emit(
        event: 'do_request',
        data: data,
      );
    }

    if (event == CHAT_EVENTS.SEND_MESSAGE) {
      data = data as ChatMessageModel;

      return emit(
        event: 'do_chat',
        data: {
          'id': data.chatId,
          'local_id': data.localId,
          'seq': data.seq,
          'content': {
            'type': data.type,
            'data': data.data,
          }
        },
      );
    }

    if (event == CHAT_EVENTS.DELETE_MESSAGE) {
      return emit(
        event: 'do_message_action',
        data: {
          'action': 'delete',
          'message_id': data['message_id'],
          'method': data['all'] == true ? 'all' : 'one',
        },
      );
    }

    if (event == CHAT_EVENTS.SEE_MESSAGE) {
      return emit(
        event: 'do_message_action',
        data: {
          'action': 'read',
          ...data,
        },
      );
    }

    if (event == CHAT_EVENTS.ACTION_EVENT) {
      return emit(
        event: 'do_chat_event',
        data: {
          'action': data['action'],
          'id': data['chat_id'],
        },
      );
    }

    if (event == CALL_EVENTS.ACTION) {
      return emit(
        event: 'do_call_action',
        data: {'action': data['action'], 'user_id': data['user_id']},
      );
    }
  }

  void onListen({required String event, required dynamic data}) async {
    if (event == "app_event") {
      log('[socket.service.dart] socket on app_event');

      Services.event.fire(
        event: data['event'],
        value: data['data'],
      );
    }

    if (event == "chat-action") {
      log('[socket.service.dart] socket on chat-action');

      if (data['type'] == 'delete') {
        var value = data['chat']['_id'];

        return Services.event.fire(
          event: CHAT_EVENTS.DELETE_CHAT,
          value: value,
        );
      }
    }

    if (event == "do_message_action_response" || event == "message_action") {
      log('[socket.service.dart] socket on message');

      if (data['error'] != null) {
        return;
      }

      if (data['action'] == 'delete') {
        var id = data['message']['_id'];

        return Services.event.fire(
          event: CHAT_EVENTS.ON_DELETE_MESSAGE,
          value: {
            'message_id': id,
          },
        );
      }

      if (data['action'] == 'read') {
        var id = data['message']['_id'];

        return Services.event.fire(
          event: CHAT_EVENTS.ON_SEE_MESSAGE,
          value: {
            'message_id': id,
          },
        );
      }
    }

    if (event == "do_chat_response" || event == 'chat') {
      log('[socket.service.dart] socket on chat');

      if (data['error'] != null) {
        if (data['message'] != null) {
          showSnackbar(message: data['message']);
        }

        var message = ChatMessageModel(
          localId: data['data']['local_id'].toString(),
          chatId: data['data']['id'],
          senderId: '',
          sentAt: DateTime.now(),
          type: data['data']['content']['type'],
          data: data['data']['content']['data'],
          seq: double.parse(data['data']['seq'].toString()),
          status: data['message_error'] ?? 'faild',
          meta: {},
        );

        Services.event.fire(
          event: CHAT_EVENTS.ON_RECEIVE_MESSAGE,
          value: message,
        );
        return;
      }

      try {
        var message = ChatMessageModel(
          messageId: data['_id'].toString(),
          localId: data['local_id'].toString(),
          chatId: data['chat_id'],
          senderId: data['sender_id'].toString(),
          sentAt: DateTime.parse(data['sent_at']),
          type: data['content']['type'],
          data: data['content']['data'],
          status: data['is_read'] == true ? 'seen' : 'sent',
          seq: double.parse(data['seq'].toString()),
          meta: {},
        );

        Services.event.fire(
          event: CHAT_EVENTS.ON_RECEIVE_MESSAGE,
          value: message,
        );
        return;
      } catch (e) {
        print(e);
      }
    }

    if (event.startsWith('do_request_response')) {
      var action = data['action'];
      var result = data['data'];

      if (action == "frontend.get_onlines_status") {
        var users = result['result']['users'];

        for (var user in users) {
          await Services.user.changeStatus(
            userId: user['id'].toString(),
            status: user['online_status'],
          );
        }

        Services.event.fire(event: 'reload_chats');
      }
    }
  }
}
