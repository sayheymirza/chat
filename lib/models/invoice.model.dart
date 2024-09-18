import 'package:chat/models/plan.model.dart';

class InvoiceModel {
  final int id;
  final int finalPrice;
  final int totalPrice;
  final int discountPrice;
  final List<InvoicePlanModel> plans;
  final List<String> paymentMethods;

  InvoiceModel({
    required this.id,
    required this.finalPrice,
    required this.totalPrice,
    required this.discountPrice,
    required this.plans,
    required this.paymentMethods,
  });

  static InvoiceModel get empty {
    return InvoiceModel(
      id: 0,
      finalPrice: 0,
      totalPrice: 0,
      discountPrice: 0,
      plans: [],
      paymentMethods: [],
    );
  }
}
