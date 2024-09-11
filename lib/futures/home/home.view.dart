import 'package:chat/futures/home/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return GetBuilder<HomeController>(
      builder: (controller) {
        controller.fetch();

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.fetch,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Obx(
                  () => Column(
                    children: [
                      ...controller.components,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
