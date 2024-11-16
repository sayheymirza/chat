import 'package:chat/futures/chats/chats.controller.dart';
import 'package:chat/shared/widgets/chat/chat_item.widget.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatsController());

    controller.load();

    return Scaffold(
      appBar: GradientAppBarWidget(
        title: "چت ها",
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              if (!controller.loading.value && controller.chats.isEmpty)
                const EmptyWidget(message: 'لیست خالی است'),
              for (var item in controller.chats)
                ChatItemWidget(
                  item: item,
                  onTap: () {
                    controller.open(id: item.id!);
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
    );
  }
}
