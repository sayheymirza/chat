class EventModel {
  final String event;
  final dynamic value;

  EventModel({
    required this.event,
    this.value,
  });
}

class EVENTS {
  static String NAVIGATION_BACK = 'navigation:back';
  static String NAVIGATION_PUSH = 'navigation:push';
  static String NAVIGATION_DIALOG = 'navigation:dialog';

  static String FEEDBACK = 'app:feedback';
  static String SHOW_APP_IN_STORE = 'app:show-app-in-store';
  static String UPDATE = 'app:update';
  static String PURCHASE = 'app:purchase';
  static String PURCHASE_RESULT = 'app:purchase:result';
  static String PURCHASE_NOT_CONSUMED = 'app:purchase:not-consumed';
  static String PURCHASE_NOT_CONSUMED_LIST = 'app:purchase:not-consumed-list';

  static String SOCKET_SEND_NOT_CONSUMED_PRODUCTS = "SEND_PURCHASES";
  static String SOCKET_CLEAR_CACHE = "CLEAR_APP_CACHE";
  static String SOCKET_CLEAR_DATABASE = "CLEAR_APP_DATABASE";
  static String SOCKET_LOGOUT = "LOGOUT_FROM_APP";
  static String SOCKET_REHANDSHAKE = "RE_HANDSHAKE";
  static String SOCKET_PROFILE_ME = "GET_ME";
  static String SOCKET_PROFILE_ID = "GET_USER";
  static String SOCKET_SNACKBAR = "SHOW_TOAST";
  static String SOCKET_INCOMING_CALL = "CALL_RINGING";
  static String SOCKET_INCOMING_CALL_END = "CALL_END";
  static String SOCKET_INCOMING_CALL_ACCEPT = "CALL_ACCEPT";
  static String SOCKET_INCOMING_CALL_DECLINE = "CALL_DECLINE";
  static String SOCKET_ROUTE = "ROUTE";
  static String SOCKET_ROUTE_BACK = "ROUTE_BACK";
  static String SOCKET_NOTIFICATION = "MAKE_NOTIFICATION";
  static String SOCKET_SOUND_PLAY = "SOUND_PLAY";
  static String SOCKET_SOUND_STOP = "SOUND_STOP";
  static String SOCKET_VIBRATION = "VIBRATION";
}

class EventParchaseParamsModel {
  // sku, jwt, payload
  final String sku;
  final String jwt;
  final String payload;

  EventParchaseParamsModel({
    required this.sku,
    required this.jwt,
    required this.payload,
  });
}

class EventParchaseResultModel {
  // sku, token, status
  final String sku;
  final String? jwt;
  final String? token;
  final String status;

  EventParchaseResultModel({
    required this.sku,
    required this.jwt,
    required this.token,
    required this.status,
  });

  // factory failed
  factory EventParchaseResultModel.failed(String sku) {
    return EventParchaseResultModel(
      sku: sku,
      jwt: null,
      token: null,
      status: 'failed',
    );
  }

  // factory close
  factory EventParchaseResultModel.close(String sku) {
    return EventParchaseResultModel(
      sku: sku,
      jwt: null,
      token: null,
      status: 'close',
    );
  }

  // factory success
  factory EventParchaseResultModel.success(
    String sku,
    String? jwt,
    String token,
  ) {
    return EventParchaseResultModel(
      sku: sku,
      jwt: jwt,
      token: token,
      status: 'success',
    );
  }
}
