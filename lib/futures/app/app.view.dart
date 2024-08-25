import 'package:chat/futures/account/account.view.dart';
import 'package:chat/futures/app/app.controller.dart';
import 'package:chat/futures/chats/chats.view.dart';
import 'package:chat/futures/home/home.view.dart';
import 'package:chat/futures/search/search.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppView extends GetView<AppController> {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AppController());

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(),
      body: Obx(
        () => [
          HomeView(),
          ChatsView(),
          SearchView(),
          AccountView(),
        ][controller.view.value],
      ),
    );
  }

  Widget bottomNavigationBar() {
    return Obx(
      () => SizedBox(
        height: Get.mediaQuery.padding.bottom + 80,
        child: BottomNavigationBar(
          currentIndex: controller.view.value,
          onTap: (int value) {
            controller.setView(value);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: "app_name".tr,
            ),
            // chats
            const BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.chat),
                  Positioned(
                    top: -5,
                    right: 14,
                    child: Badge(
                      label: Text(
                        '0',
                      ),
                    ),
                  ),
                ],
              ),
              label: "چت ها",
            ),
            // search
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "جستجو",
            ),
            // account
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "حساب کاربری",
            ),
          ],
        ),
      ),
    );
  }
}
