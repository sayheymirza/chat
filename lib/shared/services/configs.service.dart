import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfigsService extends GetxService {
  var _storage = GetStorage();

  void setFromMap(Map<String, dynamic> value) {
    for (var key in value.keys) {
      _storage.write(key, value[key]);
      // log('[configs.service.dart] set $key=${value[key]}');
    }
  }

  void set({required String key, required dynamic value}) {
    _storage.write(key, value);
    // log('[configs.service.dart] set $key=${value.toString()}');
  }

  Future<void> unset({required String key}) async {
    await _storage.remove(key);
    log('[configs.service.dart] unset $key');
  }

  T? get<T>({required String key}) {
    var value = _storage.read<T?>(key);
    // log('[configs.service.dart] get $key=${value.toString()}');
    return value;
  }

  Future<void> clear() async {
    await _storage.erase();
    log('[configs.service.dart] clear');
  }
}
