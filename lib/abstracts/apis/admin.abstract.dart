import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class AdminAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ApiAdminListResponse> list({
    int page = 1,
    int limit = 20,
    DateTime? syncDate,
  });

  Future<ApiAdminChatOneResponse?> one({
    required String chatId,
  });


  Future<ApiChatMessagesResponse> messages({
    required String chatId,
    required int limit,
    required int page,
    required ApiChatMessageOperator operator,
    int? seq,
  });
}
