class IncomingCallModel {
  final String avatar;
  final String fullname;
  final String mode;

  IncomingCallModel({
    required this.avatar,
    required this.fullname,
    required this.mode,
  });
}

class CALL_ACTIONS {
  static String HEARTBEAT = "HEARTBEAT";
  static String ACCEPT = "ACCEPT";
  static String DECLINE = "DECLINE";
  static String END = "END";
}