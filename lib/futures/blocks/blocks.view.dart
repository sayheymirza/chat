import 'package:chat/futures/blocks/blocks.controller.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlocksView extends GetView<BlocksController> {
  const BlocksView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BlocksController());

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: 'بلاکی ها',
        colors: [
          Colors.red.shade500,
          Colors.red.shade700,
        ],
      ),
      body: Column(
        children: [
          TabBar(
            labelColor: Colors.red.shade600,
            indicatorColor: Colors.red.shade600,
            controller: controller.tab,
            onTap: (_) {
              controller.onTabChange();
            },
            tabs: const [
              Tab(
                text: "بلاکی های من",
              ),
              Tab(
                text: "بلاک کنندگان من",
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
                last: controller.lastPage.value,
                page: controller.page.value,
                color: Colors.red.shade600,
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
