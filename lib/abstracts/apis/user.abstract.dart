import 'dart:io';

import 'package:chat/models/apis/user.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ApiUserAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ProfileModel?> me();

  Future<ProfileModel?> one({required int id});

  Future<ApiUserSearchResponseModel> search({
    int page = 1,
    int limit = 10,
    required ApiUserSearchFilterRequestModel filter,
  });

  Future<ApiUserUpdateResponseModel> update(ProfileModel profile);

  Future<ApiUserChangeAvatarResponseModel> changeAvatar({
    required File file,
    required Function(int precent) callback,
  });

  Future<bool> deleteAvatar();

  Future<ApiUserOTPRequestResponseModel> requestOTP();

  Future<ApiUserOTPVerifyResponseModel> verifyOTP({
    required String code,
  });

  Future<ApiUserChangeResponseModel> changePassword({required String password});

  Future<ApiUserChangeResponseModel> changePhone({required String phone});

  Future<bool> changeSettings(ApiUserChangeSettingsRequestModel request);
}
