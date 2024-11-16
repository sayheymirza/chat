import 'package:drift/drift.dart';

class DropdownTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get value => text()();
  TextColumn get groupKey => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get parentId => text().nullable()();
}
