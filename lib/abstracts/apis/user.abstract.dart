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
}
