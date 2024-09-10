import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tab;

  RxList<ProfileSearchModel> profiles = List<ProfileSearchModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;

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
    submit();
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    submit();
  }

  void submit() async {
    if (loading.value == true) return;
    try {
      loading.value = true;
      var result = await ApiService.user.reacts(
        page: page.value,
        action: tab.index == 1
            ? RELATION_ACTION.FAVORITE
            : RELATION_ACTION.FAVORITED,
      );

      lastPage.value = result.lastPage;
      profiles.value = result.profiles;

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }
}
