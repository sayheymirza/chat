import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxString status = 'در حال اتصال به سرور'.obs;

  @override
  void onInit() async {
    super.onInit();

    await fetchAndSaveDropdowns();

    await move();
  }

  Future<void> move() async {
    // check access token exists in storage or not
    var accessToken = Services.configs.get(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

    if (accessToken != null) {
      // move to /app
      Get.offAllNamed('/app');
    } else {
      // move to /auth
      Get.offAllNamed('/auth');
    }
  }

  Future<void> fetchAndSaveDropdowns() async {
    try {
      // check dropdowns hash to reload @TODO: now i check the count
      if ((await database.select(database.dropdownTable).get()).isNotEmpty) {
        return;
      }

      status.value = 'در حال دریافت تنطیمات';

      var dropdowns = await ApiService.data.dropdowns();

      var start = DateTime.now();

      await database.delete(database.dropdownTable).go();

      await database.batch(
        (batch) {
          batch.insertAll(
            database.dropdownTable,
            dropdowns.map(
              (e) => DropdownTableCompanion.insert(
                id: e.id,
                name: e.name,
                value: e.value,
                groupKey: e.groupKey,
                orderIndex: e.orderIndex,
                parentId: e.parentId,
              ),
            ),
          );
        },
      );

      var end = DateTime.now();

      status.value = 'تنظیمات دریافت شد';

      log('[splash.controller.dart] inserted all ${dropdowns.length} dropdown items for ${end.difference(start).inMilliseconds}ms');
    } catch (e) {
      status.value = 'خطا در دریافت تنظیمات رخ داد';
    }
  }
}
