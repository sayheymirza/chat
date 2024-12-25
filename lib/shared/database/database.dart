import 'dart:io';

import 'package:chat/shared/database/cache.database.dart';
import 'package:chat/shared/database/chat.database.dart';
import 'package:chat/shared/database/dropdown.database.dart';
import 'package:chat/shared/database/json.convertor.dart';
import 'package:chat/shared/database/log.database.dart';
import 'package:chat/shared/database/message.database.dart';
import 'package:chat/shared/database/sync.database.dart';
import 'package:chat/shared/database/user.database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

@DriftDatabase(
  tables: [
    DropdownTable,
    CacheTable,
    ChatTable,
    MessageTable,
    UserTable,
    SyncTable,
    LogTable
  ],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// اتصال به فایل SQLite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'database.sqlite'));
    print(file.path);
    return NativeDatabase(file);
  });
}

final database = AppDatabase();
