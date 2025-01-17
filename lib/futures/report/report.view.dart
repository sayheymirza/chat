import 'package:chat/futures/report/report.controller.dart';
import 'package:chat/shared/widgets/contact_form/contact_form.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ReportController());

    return Obx(
      () => Scaffold(
        appBar: GradientAppBarWidget(
          colors: [
            Colors.red.shade300,
            Colors.red.shade700,
          ],
          back: true,
          title: 'گزارش تخلف',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 20),
          width: Get.width - 32,
          child: ElevatedButton(
            onPressed: controller.disabled.value
                ? null
                : () {
                    controller.submit();
                  },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                controller.disabled.value
                    ? Colors.grey.shade300
                    : Colors.red.shade500,
              ),
            ),
            child: Text(
              'ارسال پیام',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ContactFormWidget(
            disabled: controller.disabled.value,
            formKey: controller.formKey,
            showReciver: false,
          ),
        ),
      ),
    );
  }
}
