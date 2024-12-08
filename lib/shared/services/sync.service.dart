import 'dart:developer';

import 'package:get/get.dart';
import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart' as drift;

class SyncService extends GetxService {
  // get by category and key
  Future<DateTime?> get({required String category, String? key}) async {
    try {
      var result = await (database.select(database.syncTable)
            ..where((tbl) {
              if (key != null) {
                return tbl.category.equals(category) & tbl.key.equals(key);
              }

              return tbl.category.equals(category);
            }))
          .getSingleOrNull();

      if (result == null) {
        return null;
      }

      return result.synced_at;
    } catch (e) {
      return null;
    }
  }

  // set by category and key and datetime
  Future<void> set({
    required String category,
    required DateTime syncedAt,
    String? key,
  }) async {
    try {
      // get the record
      var one = await (database.select(database.syncTable)
            ..where((tbl) {
              if (key != null) {
                return tbl.category.equals(category) & tbl.key.equals(key);
              }

              return tbl.category.equals(category);
            }))
          .getSingleOrNull();

      if (one == null) {
        log('[sync.service.dart] insert $category $key $syncedAt');
        await database.into(database.syncTable).insert(
              SyncTableCompanion.insert(
                category: category,
                key: drift.Value(key),
                synced_at: drift.Value(syncedAt),
              ),
            );
      } else {
        log('[sync.service.dart] update $category $key $syncedAt');
        await (database.update(database.syncTable)
              ..where((tbl) {
                if (key != null) {
                  return tbl.category.equals(category) & tbl.key.equals(key);
                }

                return tbl.category.equals(category);
              }))
            .write(
              SyncTableCompanion(
                synced_at: drift.Value(syncedAt),
              ),
            );
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  // unset by category and key
  Future<void> unset({required String category, String? key}) async {
    try {
      await (database.delete(database.syncTable)
            ..where((tbl) {
              if (key != null) {
                return tbl.category.equals(category) & tbl.key.equals(key);
              }

              return tbl.category.equals(category);
            }))
          .go();
    } catch (e) {
      return;
    }
  }

  // clear all records
  Future<void> clear() async {
    try {
      await database.delete(database.syncTable).go();
    } catch (e) {
      return;
    }
  }
}
