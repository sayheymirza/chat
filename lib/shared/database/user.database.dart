import 'package:chat/shared/database/json.convertor.dart';
import 'package:drift/drift.dart';

class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()(); // deleted/left
  TextColumn get avatar => text()();
  TextColumn get fullname => text()();
  TextColumn get last => text()(); // last seen
  TextColumn get seen => text()(); // online/recently/offline
  BoolColumn get verified => boolean().withDefault(Constant(false))();
  TextColumn get data => text().map(JsonConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
