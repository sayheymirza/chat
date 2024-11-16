import 'package:chat/shared/database/cache.database.dart';
import 'package:chat/shared/database/chat.database.dart';
import 'package:chat/shared/database/dropdown.database.dart';
import 'package:chat/shared/database/json.convertor.dart';
import 'package:chat/shared/database/message.database.dart';
import 'package:chat/shared/database/user.database.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    DropdownTable,
    CacheTable,
    ChatTable,
    ChatParticipantTable,
    MessageTable,
    UserTable
  ],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'database');
  }
}

final database = AppDatabase();
