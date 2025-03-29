import 'dart:developer';

import 'package:chat/futures/purchase/purchase.controller.dart';
import 'package:chat/shared/snackbar.dart';
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
      button.value = "مرحله بعد پرداخت";
    }
    if (index.value == 2) {
      index.value = 1;
      title.value = "فاکتور شما";
      button.value = "مرحله بعد پرداخت";
      cardByCardFormKey.currentState!.reset();
    }

    log('[purchase/one-step.controller.dart] back to $index');
  }

  void next() async {
    if (index.value == 0) {
      var value = await createInvoice();

      if (value != null) {
        index.value = 1;
        title.value = 'فاکتور شما';
        button.value = "مرحله بعد پرداخت";
      }
    } else if (index.value == 1) {
      if (selectedPaymentMethod.value == "psp") {
        await submitWithPSP();
      } else if (selectedPaymentMethod.value == "cafebazaar") {
        await submitWithCafebazaar();
      } else if (selectedPaymentMethod.value == "card-by-card") {
        index.value = 2;
        title.value = 'کارت به کارت';
        button.value = "تایید و ارسال";
      } else {
        showSnackbar(message: 'یک روش پرداخت را انتخاب کنید');
      }
    } else if (index.value == 2) {
      await submitCardByCard();
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
