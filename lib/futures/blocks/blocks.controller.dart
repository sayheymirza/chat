import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlocksController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tab;

  RxList<ProfileSearchModel> profiles = List<ProfileSearchModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxList<dynamic> pagination_history = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tab = TabController(vsync: this, length: 2);

    submit();
  }

  void onTabChange() {
    page.value = 1;
    profiles.value = List<ProfileSearchModel>.empty();
    lastPage.value = 0;
    onPageChange(tab.index == 0 ? 1 : 0);
    submit();
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    onPageChange(tab.index);
    page.value = value;
    submit();
  }

  void submit() async {
    if (loading.value == true) return;

    try {
      loading.value = true;
      var result = await ApiService.user.reacts(
        page: page.value,
        action:
            tab.index == 1 ? RELATION_ACTION.BLOCK : RELATION_ACTION.BLOCKED,
      );

      lastPage.value = result.lastPage;
      profiles.value = result.profiles;

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  void onPageChange(int tab) {
    pagination_history.add({
      "page": page.value,
      "tab": tab,
    });
  }

  void onBack() {
    var last = pagination_history.removeLast();

    print(last);

    page.value = last['page'];
    // tab.index = last['tab'];
    tab.animateTo(last['tab']);

    submit();
  }
}
