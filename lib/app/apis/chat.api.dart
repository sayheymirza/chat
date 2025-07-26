import 'package:chat/abstracts/apis/chat.abstract.dart';
import 'package:chat/app/shared/formats/chat.format.dart';
import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart';

class ApiChat extends ChatAbstract {
  @override
  Future<ApiChatCreateWithUserResponse?> createWithUserId({
    required String userId,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/chats/create-pv-chat',
        method: "POST",
        auth: true,
        data: {"user_id": int.parse(userId)},
      );

      if (result['status']) {
        return ApiChatCreateWithUserResponse(
          chatId: result['result']['chat_id'],
          permissions: '',
        );
      }

      return null;
    } on DioException catch (e) {
      print(e.response!.data);

      return null;
    }
  }

  @override
  Future<ApiChatListResponse> list({
    int page = 1,
    int limit = 20,
    DateTime? syncDate,
  }) async {
    Map<String, dynamic> data = {'limit': limit, 'page': page};

    if (syncDate != null) {
      // data['sync_date'] = syncDate.toString();
    }

    try {
      var result = await http.request(
        method: 'POST',
        path: '/api/v1/chats',
        auth: true,
        data: data,
      );

      if (result['status']) {
        return ApiChatListResponse(
          page: result['result']['meta']['page'],
          last: result['result']['meta']['totalPages'],
          limit: result['result']['meta']['limit'],
          total: result['result']['meta']['totalCount'],
          chats: (result['result']['data'] as List)
              .map((json) => fromJsonToChat(json))
              .toList(),
        );
      }

      return ApiChatListResponse.empty;
    } catch (e) {
      print(e);
      return ApiChatListResponse.empty;
    }
  }

  @override
  Future<ApiChatCreateWithChatResponse?> createWithChatId({
    required String chatId,
  }) async {
    try {
      var result = await http.request(
        path: "/api/v1/chats/get-pv-chat",
        method: "POST",
        auth: true,
        data: {'id': chatId},
      );

      if (result['status']) {
        return ApiChatCreateWithChatResponse(
          userId: result['result']['chat']['participant']['id'].toString(),
          permissions: '',
          unread_count: result['result']['chat']['unread_count'],
        );
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<ApiChatMessagesResponse> messages({
    required String chatId,
    required int limit,
    required int page,
    required ApiChatMessageOperator operator,
    double? seq,
    CancelToken? cancelToken,
  }) async {
    try {
      var data = {
        'page': page,
        'limit': limit,
        'id': chatId,
        'operator': operator.toString().split('.').last.toLowerCase(),
      };

      if (seq != null) {
        data['seq'] = seq;
      }

      var result = await http.request(
        path: '/api/v2/chats/get-pv-chat/messages',
        method: "POST",
        auth: true,
        data: data,
        cancelToken: cancelToken,
      );

      var profile = Services.profile.loadMyProfile();
      var userId = profile?.id;

      if (result['status'] && result['result']['chat'] != null) {
        List<ChatMessageModel> list = [];

        for (var chat in result['result']['chat']['messages']) {
          var message = fromJsonToMessage(chat);

          if ((chat['deleted_for'] as List).contains(userId)) {
            message.status = 'deleted';
          }

          list.add(message);
        }

        return ApiChatMessagesResponse(
          messages: list,
          syncDate: DateTime.parse(result['result']['current_date']),
        );
      }

      return ApiChatMessagesResponse(messages: [], syncDate: null);
    } on DioException catch (e) {
      print('[chat.api.dart] error on list messages');
      print(e.response!.data);

      return ApiChatMessagesResponse(messages: [], syncDate: null);
    }
  }

  @override
  Future<bool> deleteChatWithChatId({required String chatId}) async {
    try {
      var result = await http.request(
        path: '/api/v1/chats/del-pv-chat',
        method: 'POST',
        auth: true,
        data: {'id': chatId},
      );

      return result['status'];
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiChatOneResponse?> one({
    required String chatId,
  }) async {
    try {
      // post request to /api/v1/chats/get-pv-chat
      var result = await http.request(
        path: '/api/v1/chats/get-pv-chat',
        method: 'POST',
        auth: true,
        data: {'id': chatId},
      );

      if (result['status']) {
        return ApiChatOneResponse(
          userId: result['result']['chat']['participant']['id'].toString(),
          permissions: (result['result']['chat']['permissions']).join(','),
          unread_count: result['result']['chat']['unread_count'],
        );
      }

      return null;
    } catch (e) {
      print(e);

      return null;
    }
  }

  @override
  Future<ApiChatCallResponse> createCallToken({
    required String chatId,
    required String userId,
    required String mode,
    required String type,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/call/start',
        method: "POST",
        auth: true,
        data: {
          'chat_id': chatId,
          'user_id': int.parse(userId),
          'mode': mode,
          'type': type,
        },
      );

      if (result['status']) {
        return ApiChatCallResponse(
          token: result['call']['token'],
          message: result['message'],
        );
      }

      return ApiChatCallResponse(
        token: null,
        message: result['message'],
        inCall: result['name'] == "CONFUSE_CALL",
      );
    } on DioException catch (e) {
      print(e.response);
      return ApiChatCallResponse(
        token: null,
        message: 'خطا در ایجاد تماس رخ داد',
      );
    }
  }
}
