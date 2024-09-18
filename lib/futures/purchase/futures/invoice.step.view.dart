import 'package:chat/futures/purchase/purchase.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseInvoiceView extends GetView<PurchaseController> {
  const PurchaseInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: controller.invoicing.value
              ? [
                  CircularProgressIndicator(),
                  Text('در حال ایجاد فاکتور'),
                ]
              : [
                  method(
                    id: "CARD_BY_CARD",
                    text: "کارت به کارت",
                    icon: Icons.payments,
                    selected: controller.selectedPaymentMethod.value ==
                        "CARD_BY_CARD",
                  ),
                ],
        ),
      ),
    );
  }

  Widget method({
    required String id,
    required String text,
    required IconData icon,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () {
        controller.selectedPaymentMethod(id);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 100,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Get.theme.primaryColor : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Get.theme.primaryColor : Colors.black,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: TextStyle(
                color: selected ? Get.theme.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
