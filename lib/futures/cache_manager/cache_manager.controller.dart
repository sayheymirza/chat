import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CacheManagerController extends GetxController {
  Map<String, Color> colors = {
    'avatar': Colors.amber.shade300,
    'image': Colors.orange.shade300,
    'video': Colors.green.shade300,
    'audio': Colors.purple.shade300,
    'voice': Colors.pink.shade300,
    'page': Colors.blue.shade300,
    'unknown': Colors.grey.shade300,
  };

  RxList<Map<String, dynamic>> categories = [
    {
      'key': 'avatar',
      'label': 'عکس های پروفایل',
      'value': 0,
      'percent': 0,
    },
    {
      'key': 'image',
      'label': 'عکس ها',
      'value': 0,
      'percent': 0,
    },
    {
      'key': 'video',
      'label': 'ویدیو ها',
      'value': 0,
      'percent': 0,
    },
    {
      'key': 'audio',
      'label': 'موزیک ها',
      'value': 0,
      'percent': 0,
    },
    {
      'key': 'voice',
      'label': 'پیام های صوتی',
      'value': 0,
      'percent': 0,
    },
    {
      'key': 'page',
      'label': 'صفحات',
      'value': 0,
      'percent': 0,
    },
    {
      'key': 'unknown',
      'label': 'دیگر',
      'value': 0,
      'percent': 0,
    }
  ].obs;

  RxInt total = 0.obs;
  RxBool loading = false.obs;

  Future<void> load() async {
    try {
      loading.value = true;
      total.value = 0;
      var result = categories.value;

      // value
      for (var i = 0; i < result.length; i++) {
        var key = result[i]['key'];
        var value = await valueByCategory(category: key);
        result[i]['value'] = value;
        total.value += value;
      }

      // percent
      for (var i = 0; i < result.length; i++) {
        if (total.value != 0) {
          result[i]['percent'] =
              ((100 * result[i]['value']) / total.value).toInt();
        } else {
          result[i]['percent'] = 0;
        }
      }

      categories.value = result;
      loading.value = false;
    } catch (e) {
      loading.value = false;
      categories.value = [];
    }
  }

  Future<int> valueByCategory({required String category}) async {
    try {
      var query = database.selectOnly(database.cacheTable);

      query.where(database.cacheTable.category.equals(category));

      query.addColumns([
        database.cacheTable.size.sum(),
      ]);

      var result = await query.getSingle();

      return result.rawData.data['c0'];
    } catch (e) {
      return 0;
    }
  }

  Future<void> deleteAll() async {
    await Services.cache.delete();
    showSnackbar(message: 'همه فایل ها حذف شدند');
    load();
  }

  Future<void> deleteByCategory({required String category}) async {
    var item = categories.firstWhere((e) => e['key'] == category);

    if (item != null && item['value'] != 0) {
      await Services.cache.deleteByCategory(category: category);
      showSnackbar(message: 'همه فایل ها حذف شدند');
      load();
    }
  }

  Future<void> deleteUsers() async {
    await Services.user.clear();
    load();
  }

  Future<void> deleteChats() async {
    await Services.chat.clear();
    load();
  }
}
