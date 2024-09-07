import 'package:chat/futures/search/search.controller.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchViewController());

    controller.reset();

    return Scaffold(
      appBar: GradientAppBarWidget(
        title: 'جستجو کاربران',
        left: TextButton.icon(
          onPressed: () {
            controller.openFilters();
          },
          icon: Icon(
            Icons.filter_alt_rounded,
            color: Get.theme.colorScheme.onPrimary,
          ),
          label: Text(
            'فیلتر ها',
            style: TextStyle(color: Get.theme.colorScheme.onPrimary),
          ),
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in controller.profiles) profile(item),
                  if (controller.profiles.isNotEmpty)
                    PaginationWidget(
                      last: controller.lastPage.value,
                      page: controller.page.value,
                      onChange: (page) {
                        controller.goToPage(page);
                      },
                    ),
                ],
              ),
            ),
            if (controller.loading.value)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget profile(ProfileSearchModel item) {
    return UserWidget(item: item);
  }
}
