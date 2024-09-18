import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  RxInt index = 0.obs;
  RxString title = 'خرید بسته'.obs;

  RxList<PlanModel> plans = RxList.empty(growable: true);
  RxList<int> selectedPlans = RxList.empty(growable: true); // selected plans id
  RxInt finalSelectedPlansPrice = 0.obs;
  RxString selectedPaymentMethod = ''.obs;

  Rx<InvoiceModel> invoice = InvoiceModel.empty.obs;
  RxBool invoicing = false.obs;

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

  Future<void> createInvoice() async {
    try {
      invoicing.value = true;
      var result = await ApiService.purchase.createInvoice(
        plans: selectedPlans,
      );
      invoicing.value = false;

      if (result.invoice != null) {
        invoice.value = result.invoice!;
      }

      showSnackbar(message: result.message);
    } catch (e) {
      //
    }
  }
}
