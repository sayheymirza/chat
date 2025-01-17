import 'package:chat/futures/transacrion/transaction.controller.dart';
import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/formats/number.format.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransactionController());

    var id = Get.parameters['id'];

    controller.loadById(id: int.parse(id.toString()));

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: 'فاکتور $id',
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: controller.loading.value
                ? []
                : [
                    status(),
                    const ListTile(
                      dense: true,
                      title: Text('پلن های خریداری شده'),
                    ),
                    ...controller.invoice.value.plans.map(
                      (item) => plan(item: item),
                    ),
                    const ListTile(
                      dense: true,
                      title: Text('جزئیات فاکتور'),
                    ),
                    factor(),
                    image(),
                    Gap(Get.bottomBarHeight + 32),
                  ],
          ),
        ),
      ),
    );
  }

  Widget image() {
    var value = controller.invoice.value.additional?['image'];

    if (value == null) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(value),
          Positioned(
            bottom: 12,
            child: OutlinedButton.icon(
              onPressed: () {
                showSnackbar(message: 'بزودی ویژگی دانلود اضافه خواهد شد');
              },
              label: const Text('دانلود فیش'),
              icon: const Icon(Icons.download_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget factor() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          row(
            right: 'شماره فاکتور',
            left: controller.invoice.value.id.toString(),
          ),
          row(
            right: 'وضعیت',
            left: controller.invoice.value.statusText,
          ),
          row(
            right: 'مبلغ نهایی',
            left: '${formatPrice(controller.invoice.value.totalPrice)} تومان',
          ),
          row(
            right: 'مبلغ تخفیف ',
            left:
                '${formatPrice(controller.invoice.value.discountPrice)} تومان',
          ),
          row(
            right: 'مبلغ پرداخت شده',
            left: '${formatPrice(controller.invoice.value.finalPrice)} تومان',
          ),
          row(
            right: 'روش پرداخت',
            left: controller.invoice.value.paymentMethod,
          ),
          if (controller.invoice.value.isPaid)
            row(
              right: 'تاریخ پرداخت',
              left: controller.invoice.value.paidAt,
            ),
          if (controller.invoice.value.additional?['card'] != null)
            row(
              right: '4 شماره آخر کارت',
              left: controller.invoice.value.additional?['card'] ?? '',
            ),
          if (controller.invoice.value.additional?['tracking'] != null)
            row(
              right: 'کد پیگیری',
              left: controller.invoice.value.additional?['tracking'] ?? '',
            ),
          row(
            right: 'وضعیت تایید پرداخت توسط مدیریت',
            left: controller.invoice.value.verified,
          ),
          if (controller.invoice.value.verifiedAt.isNotEmpty)
            row(
              right: 'تاریخ تایید پرداخت',
              left: controller.invoice.value.verifiedAt,
            ),
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'توضیحات',
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
            subtitle: Text(
              controller.invoice.value.description,
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget plan({required PlanInvoiceModel item}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Text(
            item.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const Gap(12),
          if (item.discountPrice != 0)
            row(
              right: 'تخفیف',
              left:
                  '(${item.discount}%) ${formatPrice(item.discountPrice)} تومان',
            ),
          row(
            right: 'قیمت نهایی',
            left: '${formatPrice(item.finalPrice)} تومان',
          ),
          row(
            right: 'تاریخ شروع',
            left: item.startAt,
          ),
          row(
            right: 'تاریخ پایان',
            left: item.endAt,
          ),
        ],
      ),
    );
  }

  Widget status() {
    var value = controller.invoice.value.status;
    var text = controller.invoice.value.statusText;

    var color = Colors.white;

    switch (value) {
      case "paid":
        color = Colors.green.shade300;
        break;
      case 'processing':
      case 'to-pay':
        color = Colors.yellow.shade300;
        break;
      case 'failed':
        color = Colors.red.shade300;
        break;
      default:
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
        ],
      ),
    );
  }

  Widget row({
    required String right,
    required String left,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
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
}
