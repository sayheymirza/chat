import 'package:chat/models/plan.model.dart';

class PurchaseInvoiceModel {
  final int id;
  final int finalPrice;
  final int totalPrice;
  final int discountPrice;
  final List<InvoicePlanModel> plans;
  final List<String> paymentMethods;

  PurchaseInvoiceModel({
    required this.id,
    required this.finalPrice,
    required this.totalPrice,
    required this.discountPrice,
    required this.plans,
    required this.paymentMethods,
  });

  static PurchaseInvoiceModel get empty {
    return PurchaseInvoiceModel(
      id: 0,
      finalPrice: 0,
      totalPrice: 0,
      discountPrice: 0,
      plans: [],
      paymentMethods: [],
    );
  }
}

class SlimInvoiceModel {
  final int id;
  final String status;
  final String statusText;
  final int finalPrice;
  final String createdAt;
  final String paymentMethod;

  SlimInvoiceModel({
    required this.id,
    required this.status,
    required this.statusText,
    required this.finalPrice,
    required this.createdAt,
    required this.paymentMethod,
  });
}

class InvoiceModel {
  final int id;
  final String status;
  final String statusText;
  final int finalPrice;
  final int totalPrice;
  final int discountPrice;
  final List<PlanInvoiceModel> plans;
  final String paymentMethod;
  final bool isPaid;
  final String paidAt;
  final String verified;
  final String verifiedAt;
  final String description;
  final Map<String, dynamic>? additional;

  InvoiceModel({
    required this.id,
    required this.status,
    required this.statusText,
    required this.finalPrice,
    required this.totalPrice,
    required this.discountPrice,
    required this.plans,
    required this.paymentMethod,
    required this.isPaid,
    required this.paidAt,
    required this.verified,
    required this.verifiedAt,
    required this.description,
    required this.additional,
  });

  static InvoiceModel get empty {
    return InvoiceModel(
      id: 0,
      status: 'unknown',
      statusText: 'نامشخص',
      finalPrice: 0,
      totalPrice: 0,
      discountPrice: 0,
      plans: [],
      paymentMethod: 'نامشخص',
      isPaid: false,
      paidAt: 'نامشخص',
      description: '',
      verified: 'نامشخص',
      verifiedAt: 'نامخشص',
      additional: null,
    );
  }
}
