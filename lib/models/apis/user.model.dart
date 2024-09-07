import 'package:chat/models/profile.model.dart';

class ApiUserChangeAvatarResponseModel {
  final bool success;
  final String? url;

  ApiUserChangeAvatarResponseModel({
    required this.success,
    required this.url,
  });

  static get unhandledError {
    return ApiUserChangeAvatarResponseModel(
      success: false,
      url: null,
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

  static get empty {
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
