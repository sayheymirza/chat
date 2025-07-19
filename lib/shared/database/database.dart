import 'package:chat/shared/database/admin-chat.database.dart';
import 'package:chat/shared/database/cache.database.dart';
import 'package:chat/shared/database/chat.database.dart';
import 'package:chat/shared/database/dropdown.database.dart';
import 'package:chat/shared/database/json.convertor.dart';
import 'package:chat/shared/database/log.database.dart';
import 'package:chat/shared/database/message.database.dart';
import 'package:chat/shared/database/sync.database.dart';
import 'package:chat/shared/database/user.database.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    DropdownTable,
    CacheTable,
    ChatTable,
    MessageTable,
    UserTable,
    SyncTable,
    LogTable,
    AdminChatTable
  ],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase([QueryExecutor? e])
      : super(
          e ??
              driftDatabase(
                name: 'database',
                native: const DriftNativeOptions(
                  databaseDirectory: getApplicationSupportDirectory,
                ),
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                  onResult: (result) {
                    if (result.missingFeatures.isNotEmpty) {
                      debugPrint(
                        'Using ${result.chosenImplementation} due to unsupported '
                        'browser features: ${result.missingFeatures}',
                      );
                    }
                  },
                ),
              ),
        );

  @override
  int get schemaVersion => 1;

  Future<void> deleteEverything() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

final database = AppDatabase();
