import 'dart:async';
import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_connection/dialog_connection.view.dart';
import 'package:chat/models/apis/purchase.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  RxInt index = 0.obs;
  RxString title = 'خرید بسته'.obs;
  RxString button = 'مرحله بعد و پرداخت'.obs;

  RxList<PlanModel> plans = RxList.empty(growable: true);
  RxList<int> selectedPlans = RxList.empty(growable: true); // selected plans id
  RxInt finalSelectedPlansPrice = 0.obs;
  RxString selectedPaymentMethod = ''.obs;

  Rx<PurchaseInvoiceModel> invoice = PurchaseInvoiceModel.empty.obs;
  RxBool disabled = false.obs;

  GlobalKey<FormBuilderState> cardByCardFormKey = GlobalKey<FormBuilderState>();

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.PURCHASE_RESULT) {
        if (data.value != null) {
          var result = data.value as EventParchaseResultModel;

          if (result.status == "success") {
            consumeWithCafebazaar(
              purchaseToken: result.token!,
              sku: result.sku,
            );
          } else if (result.status == "failed") {
            showSnackbar(message: 'پرداخت ناموفق بود');
          } else if (result.status == "close") {
            showSnackbar(message: 'پرداخت توسط شما لغو شد');
          }
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    subevents?.cancel();
  }

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

  Future<PurchaseInvoiceModel?> createInvoice() async {
    try {
      disabled.value = true;
      var result = await ApiService.purchase.createInvoice(
        plans: selectedPlans,
      );
      disabled.value = false;

      if (result.invoice != null) {
        invoice.value = result.invoice!;
      }

      if (result.status == false) {
        showSnackbar(message: result.message);
      }

      return result.invoice;
    } catch (e) {
      disabled.value = false;

      return null;
    }
  }

  Future<void> submitWithCafebazaar() async {
    try {
      await Get.bottomSheet(DialogConnectionView(type: 'purchase'));

      disabled.value = true;

      var result = await ApiService.purchase.payInvoiceWithCafebazaar(
        invoiceId: invoice.value.id,
      );

      disabled.value = false;

      if (result == null) {
        showSnackbar(message: 'خطا در انتقال به درگاه پرداخت رخ داد');
        return;
      }

      Services.event.fire(
        event: EVENTS.PURCHASE,
        value: EventParchaseParamsModel(
          sku: result.sku!,
          jwt: result.jwt ?? '',
          payload: result.payload!,
        ),
      );
    } catch (e) {
      //
    }
  }

  Future<void> consumeWithCafebazaar({
    required String purchaseToken,
    required String sku,
  }) async {
    try {
      disabled.value = true;

      var packageInfo = await Services.access.generatePackageInfo();

      var result = await ApiService.purchase.consumeInvoiceWithCafebazaar(
        purchaseToken: purchaseToken,
        sku: sku,
        packageName: packageInfo.packageName,
      );

      disabled.value = false;

      if (result.status) {
        return Get.offAllNamed('/payment', parameters: {'status': 'ok'});
      }

      showSnackbar(message: result.message);
    } catch (e) {
      disabled.value = false;
    }
  }

  Future<void> submitWithPSP() async {
    try {
      await Get.bottomSheet(DialogConnectionView(type: 'purchase'));

      disabled.value = true;

      var callback = CONSTANTS.PAYMENT_CALLBACK;

      if (callback.isEmpty) {
        var package = await Services.access.generatePackageInfo();
        callback = 'app://${package.packageName}/payment';
      }

      var result = await ApiService.purchase.payInvoiceWithPSP(
        invoiceId: invoice.value.id,
        callback: callback,
      );

      disabled.value = false;

      if (result != null && result['status']) {
        Services.launch.launch(
          result['result']['payment_url'],
          mode: "external",
        );
      } else if (result != null) {
        showSnackbar(message: result['message']);
      }
    } catch (e) {
      disabled.value = false;
      showSnackbar(message: 'خطا در انتقال به درگاه پرداخت رخ داد');
    }
  }

  Future<bool> submitCardByCard() async {
    try {
      if (cardByCardFormKey.currentState!.saveAndValidate()) {
        disabled.value = true;

        var value = cardByCardFormKey.currentState!.value;

        var [year, month, day] = value['date']
            .toString()
            .split('/')
            .map((e) => int.parse(e))
            .toList();

        var result = await ApiService.purchase.payInvoiceByCardByCard(
          params: ApiPurchasePayByCardByCardParamsModel(
            invoiceId: invoice.value.id,
            year: year,
            month: month,
            day: day,
            hour: int.parse(value['hour'].toString()),
            minute: int.parse(value['minute'].toString()),
            tracking: value['tracking'].toString(),
            card: value['card'].toString(),
            description: value['description'] ?? '',
            image: value['image'],
          ),
        );

        if (result.status) {
          Get.back(canPop: true);
        }

        showSnackbar(message: result.message);

        return result.status;
      }

      disabled.value = false;

      return false;
    } catch (e) {
      disabled.value = false;

      return false;
    }
  }
}
