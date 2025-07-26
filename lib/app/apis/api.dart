import 'package:chat/app/apis/admin.api.dart';
import 'package:chat/app/apis/auth.api.dart';
import 'package:chat/app/apis/chat.api.dart';
import 'package:chat/app/apis/data.api.dart';
import 'package:chat/app/apis/purchase.api.dart';
import 'package:chat/app/apis/socket.dart';
import 'package:chat/app/apis/user.api.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  static SocketService get socket => Get.find(tag: 'api:socket');
  static ApiData get data => Get.find(tag: 'api:data');
  static ApiAuth get auth => Get.find(tag: 'api:auth');
  static ApiUser get user => Get.find(tag: 'api:user');
  static ApiPurchase get purchase => Get.find(tag: 'api:purchase');
  static ApiChat get chat => Get.find(tag: 'api:chat');
  static ApiAdmin get admin => Get.find(tag: 'api:admin');

  static void put() {
    Get.lazyPut(() => SocketService(), tag: 'api:socket');
    Get.lazyPut(() => ApiData(), tag: 'api:data');
    Get.lazyPut(() => ApiAuth(), tag: 'api:auth');
    Get.lazyPut(() => ApiUser(), tag: 'api:user');
    Get.lazyPut(() => ApiPurchase(), tag: 'api:purchase');
    Get.lazyPut(() => ApiChat(), tag: 'api:chat');
    Get.lazyPut(() => ApiAdmin(), tag: 'api:admin');
  }
}
