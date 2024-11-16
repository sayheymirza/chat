import 'package:drift/drift.dart';

class ChatTable extends Table {
  TextColumn get id => text()();
  TextColumn get permissions => text()();
  BoolColumn get typing => boolean().withDefault(Constant(false))();
  IntColumn get unread_count => integer().withDefault(Constant(0))();
  DateTimeColumn get updated_at =>
      dateTime().withDefault(Constant(DateTime.now()))();
}

class ChatParticipantTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get user_id => text()();
  TextColumn get chat_id => text()();
}
