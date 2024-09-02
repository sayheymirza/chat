class EventModel {
  final String event;
  final dynamic value;

  EventModel({
    required this.event,
    this.value,
  });
}

class EVENTS {
  static String FEEDBACK = 'app:feedback';
  static String SHOW_APP_IN_STORE = 'app:show-app-in-store';
}
