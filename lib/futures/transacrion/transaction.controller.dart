import 'package:chat/app/apis/api.dart';
import 'package:chat/models/invoice.model.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  RxBool loading = false.obs;
  Rx<InvoiceModel> invoice = InvoiceModel.empty.obs;

  Future<void> loadById({required int id}) async {
    if (loading.value) return;

    try {
      loading.value = true;

      var result = await ApiService.purchase.invoice(id: id);
      loading.value = false;

      if (result != null) {
        invoice.value = result;
      } else {
        Get.back();
        showSnackbar(message: 'فاکتور یافت نشد');
      }
    } catch (e) {
      loading.value = false;
    }
  }
}
