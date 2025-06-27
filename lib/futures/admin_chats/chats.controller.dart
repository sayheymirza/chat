import 'dart:async';

import 'package:chat/models/chat/admin.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class AdminChatsController extends GetxController {
  RxList<AdminModel> chats = List<AdminModel>.empty(growable: true).obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxInt limit = 12.obs;
  RxBool loading = false.obs;
  StreamSubscription<AdminListModel>? stream;

  List<int> page_history = [];

  StreamSubscription<EventModel>? subevents;

  @override
  void onInit() {
    super.onInit();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.NAVIGATION_BACK) {
        pop();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    subevents!.cancel();
  }

  @override
  void onReady() {
    super.onReady();

    Services.adminChat.syncAPIWithDatabase();
    load();
  }

  void pop() {
    if (page_history.isNotEmpty) {
      var last = page_history.last;

      page.value = last;
      load();

      page_history.removeLast();
    }
  }

  void onBack() {
    if (page_history.isNotEmpty) {
      var last = page_history.last;

      page.value = last;
      load();

      page_history.removeLast();
    } else {
      NavigationBack();
      Get.back();
    }
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    page_history.add(page.value);
    page.value = value;
    load();
  }

  void open({required String id}) {
    NavigationToNamed('/app/admin/chat/$id');
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

      NavigationToNamed('/app/admin/chat', params: 'page=${page.value}');
    }
  }
}
