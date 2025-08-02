import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TransactionsController extends GetxController {
  RxList<SlimInvoiceModel> transactions = List<SlimInvoiceModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxBool disabled = false.obs;

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.NAVIGATION_BACK) {
        popPage();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    subevents!.cancel();
  }

  void onBack() {
    if (disabled.value) {
      disabled.value = false;
      return;
    }

    if (kIsWasm) {
      if (page.value - 1 == 0) {
        Get.back();
      }

      NavigationBack();
    } else {
      if (page.value - 1 == 0) {
        Get.back();
      } else {
        popPage();
      }
    }
  }

  void popPage() {
    if (page.value - 1 != 0) {
      page.value -= 1;
    }
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    navigate();
    submit();
  }

  Future<void> submit() async {
    if (loading.value == true) return;
    try {
      loading.value = true;

      var result = await ApiService.purchase.invoices(
        page: page.value,
      );

      lastPage.value = result.lastPage;
      transactions.value = result.invoices;

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  void navigate() {
    if (kIsWeb) {
      NavigationToNamed('/app/transactions', params: 'page=${page.value}');
    }
  }
}
