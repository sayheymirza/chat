import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';

class SendDefaultMessageController extends GetxController {
  RxString selected = "".obs;
  RxList<Map<String, dynamic>> messages = List<Map<String, dynamic>>.empty(
    growable: true,
  ).obs;
  RxBool disabled = false.obs;

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

  Future<void> submit() async {
    if (disabled.value) return;
    try {
      disabled.value = true;
      var userId = Get.parameters['id'] ?? Get.arguments['id'];
      var result = await ApiService.user.sendFreeMessage(
        user: userId,
        message: selected.value,
      );
      disabled.value = false;

      if (result.status) {
        Get.back();
      }

      showSnackbar(message: result.message);
    } catch (e) {
      disabled.value = false;
    }
  }
}
