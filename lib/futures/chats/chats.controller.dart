import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  RxList<ChatModel> chats = List<ChatModel>.empty(growable: true).obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxInt limit = 12.obs;
  RxBool loading = false.obs;

  void goToPage(int value) {
    if (loading.value == true) return;
    page.value = value;
    load();
  }

  void open({required String id}) {
    Get.toNamed('/app/chat/$id')!.then((_) => load());
  }

  void load() async {
    var result = await Services.chat.select(
      page: page.value,
    );

    print(result.total);

    chats.value = result.chats ?? [];
  }
}
