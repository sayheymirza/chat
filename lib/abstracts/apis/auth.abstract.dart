import 'package:chat/models/apis/auth.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ApiAuthAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ApiAuthLoginResponseModel> login({
    required String username,
    required String password,
  });

  Future<ApiAuthForgotResponseModel> forgot({
    required String username,
  });

  Future<ApiAuthLoginResponseModel> register({
    required Map<String, String?> value,
  });
}
