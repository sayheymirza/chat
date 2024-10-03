import 'package:chat/app/apis/api.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:get/get.dart';

class TransactionsController extends GetxController {
  RxList<SlimInvoiceModel> transactions = List<SlimInvoiceModel>.empty().obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxBool loading = false.obs;

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    submit();
  }

  Future<void> submit() async {
    if (loading.value == true) return;
    try {
      loading.value = true;

      var result = await ApiService.purchase.invoices(
        page: page.value,
      );

      lastPage.value = result.lastPage;
      transactions.value = result.invoices;

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }
}
