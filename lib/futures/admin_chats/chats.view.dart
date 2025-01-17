import 'package:chat/futures/admin_chats/chats.controller.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/chat/admin_chat_item.widget.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminChatsView extends GetView<AdminChatsController> {
  const AdminChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminChatsController());

    Services.adminChat.syncAPIWithDatabase();
    controller.load();

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: "پیام های مدیریت",
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () => Services.adminChat.syncAPIWithDatabase(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!controller.loading.value && controller.chats.isEmpty)
                  const EmptyWidget(message: 'لیست خالی است'),
                for (var item in controller.chats)
                  AdminChatItemWidget(
                    item: item,
                    onTap: () {
                      if (item.chatId != null) {
                        controller.open(id: item.chatId!);
                      }
                    },
                  ),
                if (controller.chats.isNotEmpty)
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
        ),
      ),
    );
  }
}
