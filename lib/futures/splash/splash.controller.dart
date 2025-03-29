import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/formats/number.format.dart';
import 'package:chat/shared/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxString status = 'در حال اتصال به سرور'.obs;
  RxBool deprecated = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await firebase();

    var result = await updateEndpointFromRemoteConfig();

    if (result) {
      await handshake();

      result = await versionCheck();

      if (result == false) {
        return;
      }

      await fetchAndSaveDropdowns();

      await move();
    } else {
      status.value = 'سروری برای اتصال یافت نشد';
    }
  }

  Future<void> move() async {
    // check access token exists in storage or not
    var accessToken = Services.configs.get(key: CONSTANTS.STORAGE_ACCESS_TOKEN);

    if (accessToken != null) {
      // move to /app
      Get.offNamed('/app');
    } else {
      // move to /auth
      Get.offNamed('/auth');
    }
  }

  Future<void> firebase() async {
    status.value = 'در حال ارتباط با فایربیس';

    await Services.firebase.init();
  }

  Future<bool> updateEndpointFromRemoteConfig() {
    status.value = 'در حال یافتن سرور';

    return Services.endpoint.init();
  }

  Future<void> handshake() async {
    try {
      status.value = 'در حال دریافت اطلاعات اپلیکیشن';
      await Services.app.handshake();
    } catch (error) {
      status.value = 'خطا در دریافت اطلاعات اپلیکیشن';
    }
  }

  Future<bool> versionCheck() async {
    // check app is deprected or not
    var currentVersion = (await Services.access.generatePackageInfo()).version;
    var deprectedVersion = Services.configs.get<String>(
      key: CONSTANTS.STORAGE_DEPRECATED_VERSION,
    );

    if (formatVersion(deprectedVersion ?? '0') >=
        formatVersion(currentVersion)) {
      deprecated.value = true;
      return false;
    }

    return true;
  }

  Future<void> fetchAndSaveDropdowns() async {
    try {
      // check dropdowns hash to reload
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
                parentId: drift.Value(e.parentId),
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
      print(e);
    }
  }

  void download() {
    Services.event.fire(event: EVENTS.SHOW_APP_IN_STORE);
  }
}
