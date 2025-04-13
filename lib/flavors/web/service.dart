import 'package:chat/abstracts/flavor.abstract.dart';
import 'package:chat/futures/dialog_feedback/dialog_feedback.view.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlavorWeb extends FlavorAbstract {
  @override
  listen() {
    event.on<EventModel>().listen((data) {
      if (data.event == EVENTS.FEEDBACK) {
        feedback();
      }
      if (data.event == EVENTS.SHOW_APP_IN_STORE) {
        showAppInStore();
      }
      if (data.event == EVENTS.UPDATE) {
        update();
      }
    });
  }

  @override
  void feedback() {
    Get.bottomSheet(
      const DialogFeedbackView(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void showAppInStore() {
    var link = Services.configs.get<String>(
      key: CONSTANTS.STORAGE_LINK_DOWNLOAD,
    );

    if (link != null && link.isNotEmpty) {
      Services.launch.launch(link, mode: "external");
    }
  }

  @override
  Future<EventParchaseResultModel> purchase(
    EventParchaseParamsModel params,
    Function(EventParchaseResultModel result) callback,
  ) {
    throw UnimplementedError();
  }

  @override
  void update() {
    var link = Services.configs.get<String>(
      key: CONSTANTS.STORAGE_LINK_DOWNLOAD,
    );

    if (link != null && link.isNotEmpty) {
      Services.launch.launch(link, mode: "external");
    }
  }
}
