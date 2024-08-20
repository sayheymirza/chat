import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownsWidgetController extends GetxController {
  RxList items = [].obs;

  Future<void> load({
    required String group,
    String? parentId,
  }) async {
    try {
      var query = database.select(database.dropdownTable);

      query.where((row) => row.groupKey.equals(group));

      if (parentId != null && parentId.isNotEmpty) {
        query.where((row) => row.parentId.equals(parentId));
      }

      query.orderBy(
        [
          (row) =>
              OrderingTerm(expression: row.orderIndex, mode: OrderingMode.asc),
        ],
      );

      var result = await query.get();

      List<DropdownMenuItem<String>> output = [];

      for (var element in result) {
        output.add(
          DropdownMenuItem<String>(
            value: element.value,
            child: Text(element.name),
          ),
        );
      }

      items.value = output;
    } catch (e) {
      print(e);
    }
  }
}
