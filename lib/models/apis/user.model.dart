import 'package:chat/models/profile.model.dart';

class ApiUserSendSMSResponseModel {
  final bool status;
  final String message;
  final int? remaining;

  ApiUserSendSMSResponseModel({
    required this.status,
    required this.message,
    this.remaining,
  });

  static get unhandledError {
    return ApiUserSendSMSResponseModel(
      status: false,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}

class ApiUserChangeSettingsRequestModel {
  bool voiceCall;
  bool videoCall;
  bool notificationReaction;
  bool notificationChat;
  bool notificationVoiceCall;
  bool notificationVideoCall;

  ApiUserChangeSettingsRequestModel({
    required this.voiceCall,
    required this.videoCall,
    required this.notificationReaction,
    required this.notificationChat,
    required this.notificationVoiceCall,
    required this.notificationVideoCall,
  });

  Map<String, bool> toJson() {
    return {
      'voiceCall': voiceCall,
      'videoCall': videoCall,
      'notificationReaction': notificationReaction,
      'notificationChat': notificationChat,
      'notificationVoiceCall': notificationVoiceCall,
      'notificationVideoCall': notificationVideoCall,
    };
  }
}

class ApiUserChangeResponseModel {
  final bool success;
  final String message;

  ApiUserChangeResponseModel({
    required this.success,
    required this.message,
  });

  static get unhandledError {
    return ApiUserChangeResponseModel(
      success: false,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}

class ApiUserOTPRequestResponseModel {
  final int ttl;
  final int end;
  final String message;

  ApiUserOTPRequestResponseModel({
    required this.ttl,
    required this.end,
    required this.message,
  });

  static get unhandledError {
    return ApiUserOTPRequestResponseModel(
      ttl: 0,
      end: DateTime.now().microsecondsSinceEpoch,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}

class ApiUserOTPVerifyResponseModel {
  final bool success;
  final String message;

  ApiUserOTPVerifyResponseModel({
    required this.success,
    required this.message,
  });

  static get unhandledError {
    return ApiUserOTPVerifyResponseModel(
      success: false,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}

class ApiUserUpdateResponseModel {
  final bool success;
  final String message;

  ApiUserUpdateResponseModel({
    required this.success,
    required this.message,
  });

  static get unhandledError {
    return ApiUserUpdateResponseModel(
      success: false,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}

class ApiUserSearchResponseModel {
  final List<ProfileSearchModel> profiles;
  final int lastPage;

  ApiUserSearchResponseModel({
    required this.profiles,
    required this.lastPage,
  });

  static ApiUserSearchResponseModel get empty {
    return ApiUserSearchResponseModel(
      profiles: [],
      lastPage: 0,
    );
  }
}

class ApiUserSearchFilterRequestModel {
  final String? province;
  final String? city;
  final String? minAge;
  final String? maxAge;
  final String? marital;
  final bool? avatar;

  ApiUserSearchFilterRequestModel({
    this.province,
    this.city,
    this.minAge,
    this.maxAge,
    this.marital,
    this.avatar,
  });

  // from form factory
  factory ApiUserSearchFilterRequestModel.fromForm(Map<String, dynamic> form) {
    return ApiUserSearchFilterRequestModel(
      province: form['province'] as String?,
      city: form['city'] as String?,
      minAge: form['minAge'] as String?,
      maxAge: form['maxAge'] as String?,
      marital: form['marital'] as String?,
      avatar: form['avatar'] as bool?,
    );
  }

  // to json factory
  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'minAge': minAge,
      'maxAge': maxAge,
      'marital': marital,
      'avatar': avatar,
    };
  }

  // empty factory

  static get empty {
    return ApiUserSearchFilterRequestModel();
  }
}
