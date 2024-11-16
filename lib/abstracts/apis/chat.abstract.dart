import 'package:chat/models/apis/chat.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ChatAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ApiChatCreateWithUserResponse?> createWithUserId({
    required String userId,
  });
}
