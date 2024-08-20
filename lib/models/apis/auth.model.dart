class ApiAuthLoginResponseModel {
  final String? token;
  final String message;

  ApiAuthLoginResponseModel({
    required this.token,
    required this.message,
  });

  static get unhandledError {
    return ApiAuthLoginResponseModel(
      token: null,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}

class ApiAuthForgotResponseModel {
  final bool success;
  final String message;

  ApiAuthForgotResponseModel({required this.success, required this.message});

  static get unhandledError {
    return ApiAuthForgotResponseModel(
      success: false,
      message: 'خطایی نامشخص رخ داده است',
    );
  }
}
