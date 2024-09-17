import 'dart:developer';

import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  RxInt index = 0.obs;
  RxString title = 'خرید بسته'.obs;

  RxList<PlanModel> plans = RxList.empty(growable: true);
  RxList<int> selectedPlans = RxList.empty(growable: true); // selected plans id
  RxInt finalSelectedPlansPrice = 0.obs;
  RxString selectedPaymentMethod = ''.obs;

  void loadPlans() {
    var value = Services.configs.get<List<Map<String, dynamic>>>(
      key: CONSTANTS.STROAGE_PLANS,
    );

    if (value != null) {
      plans.value = value
          .map(
            (element) => PlanModel.fromJson(element),
          )
          .toList();

      log('[purchase.controller.dart] load ${plans.length} plans');
    }
  }

  void selectPaymentMethod(String value) {
    selectedPaymentMethod.value = value;

    log('[purchase.controller.dart] $value selected as payment method');
  }

  void calculateFinalSelectedPlansPrice() {
    int value = 0;

    for (var id in selectedPlans) {
      var plan = plans.firstWhere((item) => item.id == id);

      value += plan.finalPrice;
    }

    finalSelectedPlansPrice.value = value;
  }
}
