import 'package:chat/models/apis/purchase.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ApiPurchaseAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<ApiPurchaseCreateInvoiceResponseModel> createInvoice(
      {required List<int> plans});
}
