import 'package:chat/shared/database/json.convertor.dart';
import 'package:drift/drift.dart';

class AdminChatTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get chat_id => text().unique()();
  // image
  TextColumn get image => text()();
  // title
  TextColumn get title => text()();
  // subtitle
  TextColumn get subtitle => text()();
  TextColumn get message =>
      text().withDefault(Constant("{}")).map(JsonConverter())();
  TextColumn get permissions => text().withDefault(Constant(''))();
  TextColumn get status => text().withDefault(Constant('normal'))();
  IntColumn get unread_count => integer().withDefault(Constant(0))();
  DateTimeColumn get updated_at =>
      dateTime()();
}
