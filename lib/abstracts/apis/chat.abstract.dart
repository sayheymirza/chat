import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/models/chat/chat.message.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ChatAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ApiChatCreateWithUserResponse?> createWithUserId({
    required String userId,
  });

  Future<ApiChatListResponse> list({
    int page = 1,
    int limit = 20,
    DateTime? syncDate,
  });

  Future<ApiChatCreateWithChatResponse?> createWithChatId({
    required String chatId,
  });

  Future<List<ChatMessageModel>> messages({
    required String chatId,
    required int limit,
    required int page,
    DateTime? syncDate,
  });

  Future<bool> deleteChatWithChatId({required String chatId});
}
