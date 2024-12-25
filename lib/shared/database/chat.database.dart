import 'package:chat/shared/database/json.convertor.dart';
import 'package:chat/shared/database/user.database.dart';
import 'package:drift/drift.dart';

class ChatTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get chat_id => text().unique()();
  TextColumn get user_id => text().references(UserTable, #id)();
  TextColumn get message =>
      text().withDefault(Constant("{}")).map(JsonConverter())();
  TextColumn get permissions => text().withDefault(Constant(''))();
  TextColumn get status => text().withDefault(Constant('normal'))();
  IntColumn get unread_count => integer().withDefault(Constant(0))();
  DateTimeColumn get updated_at => dateTime()();
}
