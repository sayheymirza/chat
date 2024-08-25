import 'package:chat/app/apis/api.dart';
import 'package:chat/models/apis/user.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  RxList<ProfileSearchModel> profiles = List<ProfileSearchModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;

  ApiUserSearchFilterRequestModel filters =
      ApiUserSearchFilterRequestModel.empty;

  void reset() {
    Future.delayed(const Duration(milliseconds: 100), () {
      page.value = 1;
      profiles.value = List<ProfileSearchModel>.empty();
      lastPage.value = 0;
      filters = ApiUserSearchFilterRequestModel.empty;
      submit();
    });
  }

  Future<void> submit() async {
    if (loading.value == true) return;
    try {
      loading.value = true;
      var result = await ApiService.user.search(
        page: page.value,
        filter: filters,
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
        submit();
      }
    });
  }
}
