import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/invoice.model.dart';

class ApiPurchaseCreateInvoiceResponseModel extends ApiSimpleResponseModel {
  final PurchaseInvoiceModel? invoice;

  ApiPurchaseCreateInvoiceResponseModel({
    required super.status,
    required super.message,
    this.invoice,
  });
}

class ApiPurchasePayByCardByCardParamsModel {
  int invoiceId;
  int year;
  int month;
  int day;
  int hour;
  int minute;
  String tracking;
  String card;
  String description;
  String image;

  ApiPurchasePayByCardByCardParamsModel({
    required this.invoiceId,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.tracking,
    required this.card,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoice_id'] = invoiceId;
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['hour'] = hour;
    data['minute'] = minute;
    data['tracking'] = tracking;
    data['card'] = card;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}

class ApiPurchaseInvoicesResponseModel {
  final List<SlimInvoiceModel> invoices;
  final int page;
  final int limit;
  final int lastPage;

  ApiPurchaseInvoicesResponseModel({
    required this.invoices,
    required this.page,
    required this.limit,
    required this.lastPage,
  });

  static ApiPurchaseInvoicesResponseModel get unhandledError {
    return ApiPurchaseInvoicesResponseModel(
      invoices: [],
      page: 0,
      limit: 0,
      lastPage: 0,
    );
  }
}

class ApiPurchaseInvoiceWithCafebazaarResponseModel {
  final String? sku;
  final String? jwt;
  final String? payload;

  ApiPurchaseInvoiceWithCafebazaarResponseModel({
    this.sku,
    this.jwt,
    this.payload,
  });
}
