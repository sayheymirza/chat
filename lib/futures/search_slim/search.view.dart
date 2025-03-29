import 'package:chat/futures/search_slim/search.controller.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchSlimView extends GetView<SearchViewSlimController> {
  const SearchSlimView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchViewSlimController());

    controller.init();
    controller.reset();

    return Obx(
      () => PopScope(
        canPop: controller.filters_history.isEmpty,
        onPopInvokedWithResult: (_, __) {
          controller.onBack();
        },
        child: Scaffold(
          appBar: GradientAppBarWidget(
            back: controller.backable.value,
            onBack: () {
              controller.onBack();
            },
            title: controller.title.value,
            colors: controller.colors,
            left: controller.filterable.value
                ? TextButton.icon(
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
                  )
                : null,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    for (var item in controller.profiles)
                      UserWidget(
                        item: item,
                        onTap: () {
                          Get.toNamed(
                            '/profile/${item.id}',
                            arguments: {
                              'id': item.id,
                              'options': true,
                            },
                          );
                        },
                      ),
                    if (controller.profiles.isNotEmpty)
                      PaginationWidget(
                        last: controller.lastPage.value,
                        page: controller.page.value,
                        color: controller.color.value,
                        onChange: (page) {
                          controller.goToPage(page);
                        },
                      ),
                  ],
                ),
              ),
              if (!controller.loading.value && controller.profiles.isEmpty)
                const EmptyWidget(
                  message: 'کاربری یافت نشد',
                ),
              if (controller.loading.value)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: controller.color.value,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
