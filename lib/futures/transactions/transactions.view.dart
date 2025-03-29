import 'package:chat/futures/transactions/transactions.controller.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/shared/formats/number.format.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionsController());

    controller.submit();

    return Obx(
      () => PopScope(
        canPop: controller.page.value == 1,
        onPopInvokedWithResult: (_, __) {
          if (controller.page.value == 1) {
            Get.back();
          } else {
            controller.goToPage(controller.page.value - 1);
          }
        },
        child: Scaffold(
          appBar: GradientAppBarWidget(
            back: controller.page.value == 1,
            onBack: () {
              if (controller.page.value == 1) {
                Get.back();
              } else {
                controller.goToPage(controller.page.value - 1);
              }
            },
            title: "تراکنش ها",
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (!controller.loading.value &&
                    controller.transactions.isEmpty)
                  const EmptyWidget(
                    message: 'شما تراکنشی ندارید',
                  ),
                ...controller.transactions.map(
                  (item) => transaction(item: item),
                ),
                if (controller.transactions.isNotEmpty)
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

  Widget transaction({required SlimInvoiceModel item}) {
    Widget row({
      required String right,
      required String left,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          children: [
            Text(right),
            const Spacer(),
            Text(
              left,
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            row(
              right: 'شماره فاکتور',
              left: item.id.toString(),
            ),
            row(
              right: 'مبلغ پرداخت شده',
              left: '${formatPrice(item.finalPrice)} تومان',
            ),
            row(
              right: 'تاریخ',
              left: item.createdAt,
            ),
            row(
              right: 'نحوه پرداخت',
              left: item.paymentMethod,
            ),
            row(
              right: 'وضعیت',
              left: item.statusText,
            ),
            const Gap(10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed('/app/transactions/${item.id}');
                },
                child: const Text('جزئیات بیشتر'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
