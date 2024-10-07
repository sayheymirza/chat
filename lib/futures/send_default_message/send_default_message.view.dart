import 'package:chat/futures/send_default_message/send_default_message.controller.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SendDefaultMessageView extends GetView<SendDefaultMessageController> {
  const SendDefaultMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SendDefaultMessageController());

    return Obx(
      () => Scaffold(
        appBar: GradientAppBarWidget(
          back: true,
          title: 'ارسال پیام علاقه مندی',
        ),
        floatingActionButton: controller.selected.isEmpty
            ? null
            : SizedBox(
                width: Get.width - 32,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'ارسال پیام',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.messages.isEmpty
                ? []
                : [
                    Text(
                      'یک پیام را انتخاب کنید',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Gap(10),
                    ...controller.messages.map(
                      (e) => message(
                        text: e['text'],
                        selected: e['value'] == controller.selected.value,
                        onTap: () {
                          controller.select(e['value']);
                        },
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget message({
    required String text,
    required bool selected,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Get.theme.primaryColor.withOpacity(0.15)
              : Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Get.theme.primaryColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
