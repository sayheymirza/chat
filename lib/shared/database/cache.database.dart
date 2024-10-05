import 'package:drift/drift.dart';

class CacheTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  TextColumn get file => text()();
  IntColumn get size => integer()();
  TextColumn get category => text()();
}
