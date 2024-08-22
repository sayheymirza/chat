import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ApiUserAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ProfileModel?> me();
}
