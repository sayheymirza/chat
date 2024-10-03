import 'package:chat/models/invoice.model.dart';
import 'package:chat/shared/formats/number.format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceCardWidget extends StatelessWidget {
  final PurchaseInvoiceModel item;

  const InvoiceCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          row(
            right: "شماره فاکتور",
            left: item.id.toString(),
          ),
          ...item.plans.map(
            (element) => row(
              right: element.title,
              left: "${formatPrice(element.price)} تومان",
            ),
          ),
          row(
            right: "مبلغ کل",
            left: "${formatPrice(item.totalPrice)} تومان",
          ),
          row(
            right: "سود شما",
            left: "${formatPrice(item.discountPrice)} تومان",
          ),
          row(
            right: "مبلغ قابل پرداخت",
            left: "${formatPrice(item.finalPrice)} تومان",
          ),
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
        horizontal: 12,
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
