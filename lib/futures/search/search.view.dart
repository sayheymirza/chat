import 'package:chat/futures/search/search.controller.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends GetView<SearchViewController> {
  final String? type;

  const SearchView({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchViewController());

    controller.init(type: type);
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
                            '/app/profile/${item.id}',
                            arguments: {
                              'id': item.id,
                              'options': true,
                            },
                          )!
                              .then((_) {
                            controller.submit();
                          });
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
              if (controller.inited.value == true &&
                  controller.loading.value == false &&
                  controller.profiles.isEmpty)
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
