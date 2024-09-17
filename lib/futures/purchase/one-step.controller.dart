import 'dart:developer';

import 'package:chat/futures/purchase/purchase.controller.dart';
import 'package:get/get.dart';

class PurchaseOneStepController extends PurchaseController {
  RxInt expanded = 0.obs;

  void setExpanded(int value) {
    expanded.value = value;

    log('[purchase/one-step.controller.dart] setting expanded to $value');
  }

  void back() {
    if (index.value == 1) {
      index.value = 0;
      title.value = 'خرید بسته';
    }

    log('[purchase/one-step.controller.dart] back to $index');
  }

  void next() {
    print(selectedPaymentMethod.value);
    if (index.value == 0) {
      index.value = 1;
      title.value = 'فاکتور شما';
    } else if (index.value == 1) {
      if (selectedPaymentMethod.value == "CARD_BY_CARD") {
        index.value = 2;
        title.value = 'کارت به کارت';
      }
    }

    log('[purchase/one-step.controller.dart] next to $index');
  }

  void togglePlansById(int id) {
    // check id is in selected plans, remove or add
    if (selectedPlans.contains(id)) {
      selectedPlans.remove(id);
    } else {
      selectedPlans.value = [id];
    }

    calculateFinalSelectedPlansPrice();

    log('[purchase/one-step.controller.dart] toggled $selectedPlans');
  }
}
