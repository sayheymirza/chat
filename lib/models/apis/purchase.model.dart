import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/invoice.model.dart';

class ApiPurchaseCreateInvoiceResponseModel extends ApiSimpleResponseModel {
  final InvoiceModel? invoice;

  ApiPurchaseCreateInvoiceResponseModel({
    required super.status,
    required super.message,
    this.invoice,
  });
}
