class ApiSimpleResponseModel {
  final bool status;
  final String message;

  ApiSimpleResponseModel({
    required this.status,
    required this.message,
  });

  static ApiSimpleResponseModel get unhandledError {
    return ApiSimpleResponseModel(
      status: false,
      message: 'خطایی رخ داده است',
    );
  }
}

class ApiUploadResponseModel {
  final bool success;
  final String? url;

  ApiUploadResponseModel({
    required this.success,
    required this.url,
  });

  static get unhandledError {
    return ApiUploadResponseModel(
      success: false,
      url: null,
    );
  }
}
