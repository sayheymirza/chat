import 'dart:async';
import 'dart:developer';

import 'package:chat/models/chat/chat.model.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  RxList<ChatModel> chats = List<ChatModel>.empty(growable: true).obs;
  RxInt lastPage = 0.obs;
  RxInt page = 1.obs;
  RxInt limit = 12.obs;
  RxBool loading = false.obs;
  StreamSubscription<ChatListModel>? stream;
  StreamSubscription<EventModel>? subevents;

  List<int> page_history = [];

  @override
  void onInit() {
    super.onInit();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == 'reload_chats') {
        load(statusing: false);
      }

      if (data.event == EVENTS.NAVIGATION_BACK) {
        onBack();
      }
    });
  }

  @override
  void onClose() {
    stream?.cancel();
    subevents?.cancel();
    super.onClose();
  }

  void onBack() {
    if (page_history.isNotEmpty) {
      var last = page_history.last;

      page.value = last;
      load();

      page_history.removeLast();
    }
  }

  void goToPage(int value) {
    if (loading.value == true) return;
    page_history.add(page.value);
    page.value = value;
    navigation();
    load();
  }

  void open({required String id}) {
    NavigationToNamed('/app/chat/$id');
    Get.toNamed('/app/chat/$id')!.then((_) => load());
  }

  void load({bool statusing = true}) async {
    var result = await Services.chat.select(
      page: page.value,
      limit: 12,
    );

    chats.value = result.chats ?? [];
    lastPage.value = result.last ?? 0;

    if (statusing) {
      statuses();
    } else {
      update();
    }
  }

  void statuses() {
    var ids = chats.map((e) => e.userId!).toList();

    Services.user.statuses(userIds: ids);

    log('[chats.controller.dart] list of users are $ids');
  }

  void navigation() {
    NavigationToNamed('/app', params: 'view=1&page=${page.value}');
  }
}
