import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/apis/purchase.model.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ApiPurchaseAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ApiPurchaseCreateInvoiceResponseModel> createInvoice({
    required List<int> plans,
  });

  Future<ApiSimpleResponseModel> payInvoiceByCardByCard({
    required ApiPurchasePayByCardByCardParamsModel params,
  });

  Future<String?> payInvoiceWithPSP({
    required int invoiceId,
    required String callback,
  });

  Future<ApiPurchaseInvoicesResponseModel> invoices({
    required int page,
  });

  Future<InvoiceModel?> invoice({required int id});

  Future<ApiPurchaseInvoiceWithCafebazaarResponseModel?>
      payInvoiceWithCafebazaar({required int invoiceId});

  Future<ApiSimpleResponseModel> consumeInvoiceWithCafebazaar({
    required String purchaseToken,
    required String sku,
    required String packageName,
  });

  Future<ApiSimpleResponseModel> consumeFreePlan();
}
