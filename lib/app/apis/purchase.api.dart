import 'package:chat/abstracts/apis/purchase.abstract.dart';
import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/apis/purchase.model.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:dio/dio.dart';

class ApiPurchase extends ApiPurchaseAbstract {
  @override
  Future<ApiPurchaseCreateInvoiceResponseModel> createInvoice({
    required List<int> plans,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/create-invoice',
        method: "POST",
        auth: true,
        data: {
          "product_ids": plans,
        },
      );

      if (result['status']) {
        return ApiPurchaseCreateInvoiceResponseModel(
          status: result['status'],
          message: result['message'],
          invoice: PurchaseInvoiceModel(
            id: result['result']['invoice']['id'],
            totalPrice: result['result']['invoice']['total_amount'],
            discountPrice: result['result']['invoice']['discount_amount'],
            finalPrice: result['result']['invoice']['final_amount'],
            paymentMethods:
                List<String>.from(result['result']['payment_methods']),
            plans: (result['result']['invoice']['items'] as List<dynamic>)
                .map(
                  (element) => InvoicePlanModel(
                    title: element['product']['title'],
                    price: element['product']['final_price'],
                  ),
                )
                .toList(),
          ),
        );
      }

      return ApiPurchaseCreateInvoiceResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiPurchaseCreateInvoiceResponseModel(
        status: false,
        message: 'خطایی رخ داده است',
      );
    }
  }

  @override
  Future<ApiSimpleResponseModel> payInvoiceByCardByCard({
    required ApiPurchasePayByCardByCardParamsModel params,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/pay-invoice/card-by-card',
        method: "POST",
        auth: true,
        data: params.toJson(),
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiSimpleResponseModel.unhandledError;
    }
  }

  @override
  Future<dynamic?> payInvoiceWithPSP({
    required int invoiceId,
    required String callback,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/pay-invoice/psp',
        method: "POST",
        auth: true,
        data: {
          'invoice_id': invoiceId,
          'callback_url': callback,
        },
      );

      // if (result['status']) {
      //   return result['result']['payment_url'];
      // }

      return result;
    } on DioException catch (e) {
      print(e.response);

      return null;
    }
  }

  @override
  Future<ApiPurchaseInvoicesResponseModel> invoices({
    required int page,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/invoices',
        method: "POST",
        auth: true,
        data: {
          "page": page,
        },
      );

      if (result['status']) {
        var methods = CONSTANTS.PAYMENT_METHODS_MAP;

        return ApiPurchaseInvoicesResponseModel(
          invoices: List.from(result['result']['data'])
              .map(
                (e) => SlimInvoiceModel(
                  id: e['id'],
                  status: e['status'],
                  statusText: e['formatted_status'],
                  finalPrice: e['final_amount'],
                  createdAt: e['formatted_created_at'],
                  paymentMethod: methods[e['payment_method']] ?? 'نامشخص',
                ),
              )
              .toList(),
          page: result['result']['meta']['page'],
          limit: result['result']['meta']['limit'],
          lastPage: result['result']['meta']['totalPages'],
        );
      }

      return ApiPurchaseInvoicesResponseModel.unhandledError;
    } catch (e) {
      return ApiPurchaseInvoicesResponseModel.unhandledError;
    }
  }

  @override
  Future<InvoiceModel?> invoice({required int id}) async {
    try {
      var result = await http.request(
        path: '/api/v1/get-invoice',
        method: "POST",
        auth: true,
        data: {
          'invoice_id': id,
        },
      );

      if (result['status']) {
        var methods = CONSTANTS.PAYMENT_METHODS_MAP;

        return InvoiceModel(
          id: id,
          status: result['result']['invoice']['status'],
          statusText: result['result']['invoice']['formatted_status'],
          finalPrice: result['result']['invoice']['final_amount'],
          totalPrice: result['result']['invoice']['total_amount'],
          discountPrice: result['result']['invoice']['discount_amount'],
          plans: (result['result']['invoice']['items'] as List)
              .map(
                (e) => PlanInvoiceModel(
                  id: e['product']['id'],
                  title: e['product']['title'],
                  description: e['product']['description'],
                  category: e['product']['category'],
                  discount: e['product']['discount'],
                  price: e['product']['price'],
                  discountPrice: e['discount_price'],
                  finalPrice: e['final_price'],
                  startAt: e['formatted_created_at'],
                  endAt: e['formatted_expiration_date'],
                ),
              )
              .toList(),
          paymentMethod:
              methods[result['result']['invoice']['payment_method']] ??
                  'نامشخص',
          isPaid: result['result']['invoice']['is_paid'],
          paidAt: result['result']['invoice']['formatted_paid_at'] ?? '',
          verified: result['result']['invoice']
              ['formatted_accept_by_admin_status'],
          verifiedAt: result['result']['invoice']
                  ['formatted_accpted_by_admin_at'] ??
              '',
          description: result['result']['invoice']['description'] ??
              'توضیحاتی ثبت نشده است',
          additional: result['result']['invoice']['additional_info'],
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiPurchaseInvoiceWithCafebazaarResponseModel?>
      payInvoiceWithCafebazaar({
    required int invoiceId,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/pay-invoice/cafebazaar',
        method: "POST",
        auth: true,
        data: {
          'invoice_id': invoiceId,
        },
      );

      if (result['status']) {
        return ApiPurchaseInvoiceWithCafebazaarResponseModel(
          sku: result['result']['sku'],
          jwt: result['result']['dynamic_price_token'],
          payload: result['result']['payload'],
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiSimpleResponseModel> consumeInvoiceWithCafebazaar({
    required String purchaseToken,
    required String sku,
    required String packageName,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/pay-invoice/cafebazaar/consume',
        method: "POST",
        auth: true,
        data: {
          'purchase_token': purchaseToken,
          'sku': sku,
          'package_name': packageName,
        },
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiSimpleResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiSimpleResponseModel> consumeFreePlan() async {
    try {
      var result = await http.request(
        path: '/api/v1/get-free-account',
        method: "POST",
        auth: true,
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } on DioException catch (e) {
      print(e.response);

      return ApiSimpleResponseModel.unhandledError;
    }
  }
}
