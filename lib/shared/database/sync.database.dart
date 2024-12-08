import 'package:chat/shared/database/json.convertor.dart';
import 'package:chat/shared/database/user.database.dart';
import 'package:drift/drift.dart';

class SyncTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  // category
  TextColumn get category => text()();

  // key optional
  TextColumn get key => text().nullable()();

  // synced_at datetime
  DateTimeColumn get synced_at => dateTime().nullable()();
}
