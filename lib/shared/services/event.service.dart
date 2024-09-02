import 'dart:developer';

import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart' as instance;
import 'package:get/get.dart';

class EventService extends GetxService {
  void fire({required String event, dynamic value}) {
    log('[event.service.dart] fire event $event');

    instance.event.fire(
      EventModel(
        event: event,
        value: value,
      ),
    );
  }
}
