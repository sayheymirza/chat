import 'dart:async';

import 'package:chat/models/chat/admin.model.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class AdminChatsController extends GetxController {
  RxList<AdminModel> chats = List<AdminModel>.empty(growable: true).obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxInt limit = 12.obs;
  RxBool loading = false.obs;
  StreamSubscription<AdminListModel>? stream;

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    load();
  }

  void open({required String id}) {
    Get.toNamed('/app/admin/chat/$id')!.then((_) => load());
  }

  void load() async {
    // if page is 1 use stream to get data
    if (page.value == 1) {
      if (stream != null) return;

      var result = await Services.adminChat.list(
        page: page.value,
      );

      stream = result.listen((event) {
        chats.value = event.chats ?? [];
        lastPage.value = event.last ?? 0;
      });
    } else {
      // close stream
      stream?.cancel();
      stream = null;

      var result = await Services.adminChat.select(
        page: page.value,
      );

      chats.value = result.chats ?? [];
      lastPage.value = result.last ?? 0;
    }
  }
}
