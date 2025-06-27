import 'package:chat/futures/favorites/favorites.controller.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FavoritesController());

    return Obx(
      () => PopScope(
        canPop: controller.pagination_history.isEmpty,
        onPopInvokedWithResult: (_, __) {
          if (controller.pagination_history.isEmpty) {
            Get.back();
            NavigationBack();
          } else {
            controller.onBack();
          }
        },
        child: Scaffold(
          appBar: GradientAppBarWidget(
            back: true,
            onBack: () {
              if (controller.pagination_history.isEmpty) {
                Get.back();
              } else {
                controller.onBack();
              }
            },
            title: 'علاقه مندی ها',
            left: IconButton(
              onPressed: () => controller.onForceBack(),
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                controller: controller.tab,
                onTap: (_) {
                  controller.onTabChange();
                },
                tabs: const [
                  Tab(
                    text: "علاقه مندی های من",
                  ),
                  Tab(
                    text: "علاقه مندان به من",
                  ),
                ],
              ),
              tabView(
                loading: controller.loading.value,
                profiles: controller.profiles,
                lastPage: controller.lastPage.value,
                page: controller.page.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabView({
    required bool loading,
    required List<ProfileSearchModel> profiles,
    required int lastPage,
    required int page,
  }) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!loading && profiles.isEmpty)
              const EmptyWidget(message: 'لیست خالی است'),
            for (var item in controller.profiles)
              UserWidget(
                item: item,
                onTap: () {
                  NavigationToNamed('/app/profile/${item.id}');
                  Get.toNamed(
                    '/app/profile/${item.id}',
                    arguments: {
                      'id': item.id,
                      'options': true,
                    },
                  )!
                      .then((_) => controller.submit());
                },
              ),
            if (controller.profiles.isNotEmpty)
              PaginationWidget(
                last: controller.lastPage.value,
                page: controller.page.value,
                onChange: (page) {
                  controller.goToPage(page);
                },
              ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
