import 'dart:async';

import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  RxList<ChatModel> chats = List<ChatModel>.empty(growable: true).obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxInt limit = 12.obs;
  RxBool loading = false.obs;
  StreamSubscription<ChatListModel>? stream;

  @override
  void onClose() {
    stream?.cancel();
    super.onClose();
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    load();
  }

  void open({required String id}) {
    Get.toNamed('/app/chat/$id')!.then((_) => load());
  }

  void load() async {
    // if page is 1 use stream to get data
    if (page.value == 1) {
      if (stream != null) return;

      var result = await Services.chat.list(
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

      var result = await Services.chat.select(
        page: page.value,
      );

      chats.value = result.chats ?? [];
      lastPage.value = result.last ?? 0;
    }
  }
}
