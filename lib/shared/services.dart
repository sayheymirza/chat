import 'dart:developer';

import 'package:chat/shared/services/access.service.dart';
import 'package:chat/shared/services/app.service.dart';
import 'package:chat/shared/services/cache.service.dart';
import 'package:chat/shared/services/chrome.service.dart';
import 'package:chat/shared/services/configs.service.dart';
import 'package:chat/shared/services/event.service.dart';
import 'package:chat/shared/services/file.service.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:chat/shared/services/launch_instance.service.dart';
import 'package:chat/shared/services/notification.service.dart';
import 'package:chat/shared/services/profile.service.dart';
import 'package:chat/shared/services/queue.service.dart';
import 'package:get/get.dart';

class Services {
  static ChromeService get chrome => Get.find(tag: 'chrome');
  static HttpService get http => Get.find(tag: 'http');
  static LaunchInstanceService get launch => Get.find(tag: 'launch');
  static ProfileService get profile => Get.find(tag: 'profile');
  static ConfigsService get configs => Get.find(tag: 'configs');
  static EventService get event => Get.find(tag: 'event');
  static AppService get app => Get.find(tag: 'app');
  static QueueService get queue => Get.find(tag: 'queue');
  static AccessService get access => Get.find(tag: 'access');
  static CacheService get cache => Get.find(tag: 'cache');
  static NotificationService get notification => Get.find(tag: 'notification');
  static FileService get file => Get.find(tag: 'file');

  static put() async {
    log('[services.dart] start put Get services');
    Get.put(HttpService(), tag: 'http');
    Get.put(QueueService(), tag: 'queue');
    Get.lazyPut(() => ChromeService(), tag: 'chrome');
    Get.lazyPut(() => LaunchInstanceService(), tag: 'launch');
    Get.lazyPut(() => ProfileService(), tag: 'profile');
    Get.lazyPut(() => ConfigsService(), tag: 'configs');
    Get.lazyPut(() => EventService(), tag: 'event');
    Get.lazyPut(() => AppService(), tag: 'app');
    Get.lazyPut(() => AccessService(), tag: 'access');
    Get.lazyPut(() => CacheService(), tag: 'cache');
    Get.lazyPut(() => NotificationService(), tag: 'notification');
    Get.lazyPut(() => FileService(), tag: 'file');
    log('[services.dart] end put Get services');
  }
}
