import 'package:chat/models/log.model.dart';
import 'package:get/get.dart';
import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart' as drift;

class LogService extends GetxService {
//   add log
  Future<void> add({
    required String category,
    required String message,
  }) async {
    await (database.into(database.logTable).insert(
          LogTableCompanion.insert(
            category: category,
            message: message,
            createdAt: drift.Value(DateTime.now()),
          ),
        ));
  }

  // stream all logs by category (optional)
  Stream<List<LogModel>> stream({String? category}) {
    var query = database.select(database.logTable);

    if (category != null) {
      query.where((tbl) => tbl.category.equals(category));
    }

    // order by createdAt desc
    query.orderBy([
      (tbl) => drift.OrderingTerm(
            expression: tbl.createdAt,
            mode: drift.OrderingMode.desc,
          ),
    ]);

    return query.map((row) => LogModel.fromDatabase(row)).watch();
  }

  // clear
  Future<void> clear() async {
    await database.delete(database.logTable).go();
  }
}
