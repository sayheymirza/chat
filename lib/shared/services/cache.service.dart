import 'dart:developer';
import 'dart:io';

import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CacheService extends GetxService {
  Future<File?> load({
    required String url,
    String category = 'unknown',
    Function({
      required int percent,
      required int total,
      required int recive,
    })? onPercent,
  }) async {
    try {
      var file = await get(url: url);

      if (file != null) {
        return file;
      }

      return await put(
        url: url,
        category: category,
        onPercent: onPercent,
      );
    } catch (e) {
      return null;
    }
  }

  Future<File?> get({required String url}) async {
    try {
      var query = database.select(database.cacheTable);

      query.where((row) => row.url.equals(url));
      query.limit(1);

      var result = await query.getSingle();

      // ignore: unnecessary_null_comparison
      if (result != null) {
        // check file exists or not
        var file = File(result.file);
        
        if (file.existsSync()) {
          return file;
        } else {
          // delete it from cache database
          await deleteCacheFromDatabaseById(id: result.id);
        }
      }

      return null;
    } catch (e) {
      log('[cache.service.dart] get faild $url');

      return null;
    }
  }

  Future<File?> put({
    required String url,
    String category = 'unknown',
    Function({
      required int percent,
      required int total,
      required int recive,
    })? onPercent,
  }) async {
    try {
      var directory = Directory(
        '${(await getApplicationCacheDirectory()).path}/files/$category',
      );

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      var result = await Services.http.download(
        url: url,
        directory: directory.path,
        onPercent: onPercent,
      );

      if (result != null && result.existsSync()) {
        await database.into(database.cacheTable).insert(
              CacheTableCompanion.insert(
                url: url,
                file: result.path,
                size: result.statSync().size,
                category: category,
              ),
            );

        log('[cache.service.dart] put ${result.path}');
      }

      return result;
    } catch (e) {
      return null;
    }
  }

  Future<void> save({
    required String url,
    required String category,
    required File file,
  }) async {
    await database.into(database.cacheTable).insert(
          CacheTableCompanion.insert(
            url: url,
            file: file.path,
            size: file.statSync().size,
            category: category,
          ),
        );
  }

  Future<void> delete() async {
    try {
      await database.delete(database.cacheTable).go();
      var directory = Directory(
        '${(await getApplicationCacheDirectory()).path}/files/',
      );

      directory.deleteSync(recursive: true);
    } catch (e) {
      //
    }
  }

  Future<void> deleteByUrl({required String url}) async {}

  Future<void> deleteByCategory({required String category}) async {
    try {
      await (database.delete(database.cacheTable)
            ..where((row) => row.category.equals(category)))
          .go();
      var directory = Directory(
        '${(await getApplicationCacheDirectory()).path}/files/$category',
      );

      directory.deleteSync(recursive: true);
    } catch (e) {
      //
    }
  }

  Future<bool> deleteCacheFromDatabaseById({required int id}) async {
    try {
      var query = database.delete(database.cacheTable)
        ..where((row) => row.id.equals(id));

      var result = await query.go();

      return result == 1;
    } catch (e) {
      return false;
    }
  }
}
