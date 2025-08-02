import 'dart:async';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/search_filter/search_filter.view.dart';
import 'package:chat/models/apis/user.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  RxList<ProfileSearchModel> profiles = List<ProfileSearchModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxBool inited = false.obs;
  RxBool disabled = false.obs;

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

  RxList<ApiUserSearchFilterRequestModel> filters_history =
      <ApiUserSearchFilterRequestModel>[].obs;

  String? type;

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.NAVIGATION_BACK) {
        popFilters();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    subevents!.cancel();
  }

  void init({
    required String? type,
  }) {
    inited.value = false;
    this.type = type;
    switch (type) {
      case 'newest':
        title.value = 'جدید ترین کاربران';
        colors.value = [Colors.amber.shade500, Colors.amber.shade700];
        color.value = Colors.amber.shade600;
        backable.value = true;
        filterable.value = false;
        break;
      case 'visites':
        title.value = 'بازدیدکنندگان پروفایل من';
        colors.value = [Colors.green.shade500, Colors.green.shade700];
        color.value = Colors.green.shade600;
        backable.value = true;
        filterable.value = false;
        break;
      case 'advertised':
        title.value =
            'type'.tr == 'dating' ? 'آگهی های همسریابی' : 'آگهی های ویژه';
        colors.value = [Colors.yellow.shade500, Colors.yellow.shade700];
        color.value = Colors.yellow.shade600;
        backable.value = true;
        filterable.value = false;
        break;
      case 'search':
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
    profiles.value = List<ProfileSearchModel>.empty();

    Future.delayed(const Duration(milliseconds: 100), () {
      page.value = 1;
      lastPage.value = 0;
      filters = ApiUserSearchFilterRequestModel.empty;
      submit();
    });
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    onPageChange();
    page.value = value;
    submit();
  }

  Future<void> submit() async {
    if (loading.value == true) return;
    try {
      loading.value = true;
      var type = this.type ?? 'search';

      var result = await ApiService.user.search(
        page: page.value,
        filter: filters,
        type: type,
      );

      lastPage.value = result.lastPage;
      profiles.value = result.profiles;

      loading.value = false;
      inited.value = true;
    } catch (e) {
      loading.value = false;
      inited.value = true;
    }
  }

  void openFilters({
    Function? onPageChange,
  }) {
    Get.dialog(
      SearchFilterView(
        value: filters,
      ),
      useSafeArea: false,
    ).then((values) {
      if (values != null) {
        filters_history.add(
          filters.copyWith({
            'page': page.value,
          }),
        );

        filters = values;
        page.value = 1;
        navigate();
        submit();

        if (onPageChange != null) {
          onPageChange();
        }
      }
    });
  }

  void onForceBack() {
    // clear all histories and Get.back
    if (filters_history.isNotEmpty) {
      for (var i = 0; i < filters_history.length - 1; i++) {
        NavigationBack();
      }
    }

    filters_history.value = [];
    Get.back();
  }

  void onBack() {
    if (disabled.value) {
      disabled.value = false;
      return;
    }

    if (kIsWasm) {
      if (filters_history.isEmpty) {
        Get.back();
      }

      NavigationBack();
    } else {
      if (filters_history.isEmpty) {
        Get.back();
      } else {
        popFilters();
      }
    }
  }

  void popFilters() {
    if (filters_history.isNotEmpty) {
      var last = filters_history.last;

      filters = last;
      page.value = last.page ?? 1;
      submit();

      filters_history.removeLast();
    }
  }

  void onPageChange() {
    filters_history.add(
      filters.copyWith({
        'page': page.value,
      }),
    );
    navigate();
  }

  void navigate() {
    // convert filters_hstory to query params
    var query =
        'avatar=${filters_history.last.avatar}&city=${filters_history.last.city}&province=${filters_history.last.province}&minAge=${filters_history.last.minAge}&maxAge=${filters_history.last.maxAge}&marital=${filters_history.last.marital}&page=${filters_history.last.page}';

    if (Get.currentRoute == '/app') {
      query = '$query&view=2';
    }

    NavigationToNamed(Get.currentRoute, params: query);
  }
}
