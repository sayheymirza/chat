import 'package:chat/futures/purchase/futures/invoice-card.widget.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PurchaseInvoiceView extends StatelessWidget {
  final PurchaseInvoiceModel invoice;
  final String selectedPaymentMethod;
  final Function(String id) onSelectPaymentMethod;

  const PurchaseInvoiceView({
    super.key,
    required this.invoice,
    required this.selectedPaymentMethod,
    required this.onSelectPaymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        children: [
          const Gap(20),
          InvoiceCardWidget(
            item: invoice,
          ),
          const Gap(20),
          ListTile(
            dense: true,
            title: Text(
              'روش پرداخت را انتخاب کنید',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ...CONSTANTS.PAYMENT_METHODS.where((e) {
            return invoice.paymentMethods.contains(e['key']);
          }).map((e) {
            return method(
              id: e['key'],
              text: e['text'],
              icon: e['icon'],
              image: e['image'],
              selected: selectedPaymentMethod == e['key'],
            );
          }),
        ],
      ),
    );
  }

  Widget method({
    required String id,
    required String text,
    required bool selected,
    IconData? icon,
    String? image,
  }) {
    return GestureDetector(
      onTap: () {
        onSelectPaymentMethod(id);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 100,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Get.theme.primaryColor : Colors.grey.shade400,
            width: selected ? 3 : 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: selected ? Get.theme.primaryColor : Colors.black,
              ),
            if (image != null)
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  'lib/app/assets/images/$image.png',
                  fit: BoxFit.contain,
                ),
              ),
            const Gap(12),
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
