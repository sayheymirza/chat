import 'package:chat/abstracts/apis/auth.abstract.dart';
import 'package:chat/models/apis/auth.model.dart';

class ApiAuth extends ApiAuthAbstract {
  @override
  Future<ApiAuthLoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/login',
        method: "POST",
        data: {
          'phone': username,
          'password': password,
        },
      );

      if (result['status'] == false) {
        return ApiAuthLoginResponseModel(
          token: null,
          message: result['message'],
        );
      }

      return ApiAuthLoginResponseModel(
        token: result['result']['token'],
        message: result['message'],
      );
    } catch (e) {
      return ApiAuthLoginResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiAuthForgotResponseModel> forgot({required String username}) async {
    try {
      var result = await http.request(
        path: '/api/v1/forgot',
        method: "POST",
        data: {
          'phone': username,
        },
      );

      return ApiAuthForgotResponseModel(
        success: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiAuthForgotResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiAuthLoginResponseModel> register({
    required Map<String, String?> value,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/register',
        method: "POST",
        data: value,
      );

      if (result['status'] == false) {
        return ApiAuthLoginResponseModel(
          token: null,
          message: result['message'],
        );
      }

      return ApiAuthLoginResponseModel(
        token: result['result']['token'],
        message: result['message'],
      );
    } catch (e) {
      return ApiAuthLoginResponseModel.unhandledError;
    }
  }
}
