import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/user.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  RxList<ProfileSearchModel> profiles = List<ProfileSearchModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;

  RxBool filterable = false.obs;
  RxBool backable = false.obs;
  RxString title = 'جستجو کاربران'.obs;
  RxList<Color> colors = [
    Get.theme.primaryColor.withOpacity(0.7),
    Get.theme.primaryColor,
  ].obs;
  Rx<Color> color = Get.theme.primaryColor.obs;

  ApiUserSearchFilterRequestModel filters =
      ApiUserSearchFilterRequestModel.empty;

  void init({
    required String? type,
  }) {
    switch (type) {
      case 'newest':
        title.value = 'جدید ترین کاربران';
        colors.value = [Colors.amber.shade500, Colors.amber.shade700];
        color.value = Colors.amber.shade600;
        backable.value = true;
        filterable.value = false;
        break;
      case 'visited':
        title.value = 'بازدیدکنندگان پروفایل من';
        colors.value = [Colors.green.shade500, Colors.green.shade700];
        color.value = Colors.green.shade600;
        backable.value = true;
        filterable.value = false;
        break;
      case 'advertised':
        title.value = 'آگهی شده ها';
        colors.value = [Colors.yellow.shade500, Colors.yellow.shade700];
        color.value = Colors.yellow.shade600;
        backable.value = true;
        filterable.value = false;
        break;
      default:
        filterable.value = true;
        backable.value = false;
        title.value = 'جستجو کاربران';
        colors.value = [
          Get.theme.primaryColor.withOpacity(0.7),
          Get.theme.primaryColor,
        ];
        color.value = Get.theme.primaryColor;
        break;
    }
  }

  void reset() {
    Future.delayed(const Duration(milliseconds: 100), () {
      page.value = 1;
      profiles.value = List<ProfileSearchModel>.empty();
      lastPage.value = 0;
      filters = ApiUserSearchFilterRequestModel.empty;
      submit();
    });
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    submit();
  }

  Future<void> submit() async {
    if (loading.value == true) return;
    try {
      loading.value = true;
      var type = Get.parameters['type'] ?? 'newest';

      if (type == 'search') {
        type = 'newest';
      }

      var result = await ApiService.user.search(
        page: page.value,
        filter: filters,
        type: type,
      );

      lastPage.value = result.lastPage;
      profiles.value = result.profiles;

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  void openFilters() {
    Get.toNamed(
      '/app/search/filter',
      arguments: filters,
    )!
        .then((values) {
      if (values != null) {
        filters = values;
        page.value = 1;
        submit();
      }
    });
  }
}
