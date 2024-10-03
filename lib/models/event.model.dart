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
  static String UPDATE = 'app:update';
  static String PURCHASE = 'app:purchase';
  static String PURCHASE_RESULT = 'app:purchase:result';
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
  final String? token;
  final String status;

  EventParchaseResultModel({
    required this.sku,
    required this.token,
    required this.status,
  });

  // factory failed
  factory EventParchaseResultModel.failed(String sku) {
    return EventParchaseResultModel(
      sku: sku,
      token: null,
      status: 'failed',
    );
  }

  // factory close
  factory EventParchaseResultModel.close(String sku) {
    return EventParchaseResultModel(
      sku: sku,
      token: null,
      status: 'close',
    );
  }

  // factory success
  factory EventParchaseResultModel.success(String sku, String token) {
    return EventParchaseResultModel(
      sku: sku,
      token: token,
      status: 'success',
    );
  }
}
