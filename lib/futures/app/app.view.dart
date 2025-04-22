import 'package:chat/futures/account/account.view.dart';
import 'package:chat/futures/app/app.controller.dart';
import 'package:chat/futures/chats/chats.view.dart';
import 'package:chat/futures/dialog_back/dialog_back.view.dart';
import 'package:chat/futures/home/home.view.dart';
import 'package:chat/futures/search/search.view.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppView extends GetView<AppController> {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AppController());

    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          if (controller.viewsHistory.isNotEmpty) {
            controller.back();
          } else {
            Get.bottomSheet(
              DialogBackView(),
            ).then((value) {
              if (value == true) {
                if (GetPlatform.isAndroid) {
                  SystemNavigator.pop();
                }
              }
            });
          }
        },
        child: Scaffold(
          bottomNavigationBar: bottomNavigationBar(
            context,
          ),
          body: [
            const HomeView(),
            ChatsView(
              onPageChange: () {
                controller.setView(controller.view.value);
              },
            ),
            SearchView(
              type: 'search',
              onPageChange: () {
                controller.setView(controller.view.value);
              },
            ),
            const AccountView(),
          ][controller.view.value],
        ),
      ),
    );
  }

  Widget connection({
    required String status,
  }) {
    Color color = Colors.white;
    String text = '';

    switch (status) {
      case 'errored':
        color = Colors.red;
        text = 'خطا در اتصال رخ داد';
        break;
      case 'connecting':
        color = Colors.blue.shade300;
        text = 'در حال اتصال';
        break;
      case 'disconnected':
        color = Colors.red.shade300;
        text = 'اتصال بر قرار نشد';
        break;
      case 'reconnecting':
        color = Colors.amber.shade300;
        text = 'در حال اتصال مجدد';
        break;
      default:
    }

    return Container(
      height: 32,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).padding.bottom +
            80 +
            (controller.socket.status.value != 'connected' ? 32 : 0),
        child: Column(
          children: [
            if (controller.socket.status.value != 'connected')
              connection(
                status: controller.socket.status.value,
              ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 80,
              child: BottomNavigationBar(
                currentIndex: controller.view.value,
                onTap: (int value) {
                  controller.setView(value);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.dark_mode),
                    label: "app_name".tr,
                  ),
                  // chats
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.chat),
                        Positioned(
                          top: -5,
                          right: 14,
                          child: StreamBuilder(
                            stream: Services.chat.listenToUnreadedChats(),
                            builder: (context, snapshot) {
                              var count = snapshot.data ?? 0;

                              return Badge(
                                label: Text(
                                  count.toString(),
                                ),
                              );
                            },
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
          ],
        ),
      ),
    );
  }
}
