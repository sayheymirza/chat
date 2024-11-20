import 'package:chat/shared/database/json.convertor.dart';
import 'package:drift/drift.dart';

class MessageTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get message_id => text().nullable()();
  TextColumn get local_id => text().nullable()();
  TextColumn get chat_id => text()();
  TextColumn get status =>
      text().withDefault(Constant('unknown'))(); // sent | uploading | sending
  TextColumn get sender_id => text()();
  DateTimeColumn get sent_at =>
      dateTime().withDefault(Constant(DateTime.now()))();
  TextColumn get type => text()();
  TextColumn get data => text().map(JsonConverter())();
  TextColumn get meta => text().map(JsonConverter())();
  IntColumn get seq => integer().withDefault(Constant(0))();
  TextColumn get reply_message_id => text().nullable()();
  TextColumn get reaction => text().nullable()();
}
