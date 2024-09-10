import 'package:chat/futures/favorites/favorites.controller.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FavoritesController());

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: 'علاقه مندی ها',
        colors: [
          Colors.pink.shade500,
          Colors.pink.shade700,
        ],
      ),
      body: Column(
        children: [
          TabBar(
            labelColor: Colors.pink.shade600,
            indicatorColor: Colors.pink.shade600,
            controller: controller.tab,
            onTap: (_) {
              controller.onTabChange();
            },
            tabs: const [
              Tab(
                text: "علاقه مندی های من",
              ),
              Tab(
                text: "علاقه مندان من",
              ),
            ],
          ),
          Obx(
            () => tabView(
              loading: controller.loading.value,
              profiles: controller.profiles,
              lastPage: controller.lastPage.value,
              page: controller.page.value,
            ),
          ),
        ],
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
            for (var item in controller.profiles) UserWidget(item: item),
            if (controller.profiles.isNotEmpty)
              PaginationWidget(
                color: Colors.pink.shade600,
                last: controller.lastPage.value,
                page: controller.page.value,
                onChange: (page) {
                  controller.goToPage(page);
                },
              ),
          ],
        ),
      ),
    );
  }
}
