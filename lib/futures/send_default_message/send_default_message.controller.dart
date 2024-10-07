import 'dart:developer';

import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';

class SendDefaultMessageController extends GetxController {
  RxString selected = "".obs;
  RxList<Map<String, dynamic>> messages = List<Map<String, dynamic>>.empty(
    growable: true,
  ).obs;

  @override
  void onInit() async {
    super.onInit();

    var query = database.select(database.dropdownTable);

    query.where((row) => row.groupKey.equals('PrepairedMessages'));

    query.orderBy([
      (row) => OrderingTerm(
            expression: row.orderIndex,
            mode: OrderingMode.asc,
          ),
    ]);

    var result = await query.get();

    List<Map<String, dynamic>> output = [];

    for (var element in result) {
      output.add({
        "value": element.value,
        "text": element.name,
      });
    }

    messages.value = output;
  }

  void select(String value) {
    selected.value = value;
    log('[send_default_message.controller.dart] select $value');
  }
}
