import 'package:chat/abstracts/apis/admin.abstract.dart';
import 'package:chat/app/shared/formats/admin.format.dart';
import 'package:chat/app/shared/formats/chat.format.dart';
import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services.dart';
import 'package:dio/dio.dart';

class ApiAdmin extends AdminAbstract {
  @override
  Future<ApiAdminListResponse> list({
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
        path: '/api/v1/chats?type=admin',
        auth: true,
        data: data,
      );

      if (result['status']) {
        return ApiAdminListResponse(
          page: result['result']['meta']['page'],
          last: result['result']['meta']['totalPages'],
          limit: result['result']['meta']['limit'],
          total: result['result']['meta']['totalCount'],
          chats: (result['result']['data'] as List)
              .map((json) => fromJsonToAdmin(json))
              .toList(),
        );
      }

      return ApiAdminListResponse.empty;
    } catch (e) {
      print(e);
      return ApiAdminListResponse.empty;
    }
  }

  @override
  Future<ApiChatMessagesResponse> messages({
    required String chatId,
    required int limit,
    required int page,
    required ApiChatMessageOperator operator,
    int? seq,
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

      var userId = int.parse(Services.profile.profile.value.id!);

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
      print(e.response!.data);

      return ApiChatMessagesResponse(messages: [], syncDate: null);
    }
  }

  @override
  Future<ApiAdminChatOneResponse?> one({
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
        return ApiAdminChatOneResponse(
          title: result['result']['chat']['title'],
          subtitle: result['result']['chat']['sender_name'],
          image: result['result']['chat']['avatar'],
          permissions: (result['result']['chat']['permissions']).join(','),
          unread_count: result['result']['chat']['unread_count'],
          updated_at:
              DateTime.parse(result['result']['chat']['last_message_at']),
        );
      }

      return null;
    } catch (e) {
      print(e);

      return null;
    }
  }
}
