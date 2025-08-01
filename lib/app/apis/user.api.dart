import 'dart:io';

import 'package:chat/abstracts/apis/user.abstract.dart';
import 'package:chat/app/shared/formats/profile.format.dart';
import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/apis/user.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:dio/dio.dart';

class ApiUser extends ApiUserAbstract {
  @override
  Future<ProfileModel?> me() async {
    try {
      var result = await http.request(
        path: '/api/v1/me',
        auth: true,
      );

      if (result['status'] == true) {
        var profile = fromJsonToProfile(result['result']);

        return profile;
      }

      return null;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<ApiUserSearchResponseModel> search({
    int page = 1,
    int limit = 12,
    String type = "newest",
    required ApiUserSearchFilterRequestModel filter,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/search',
        auth: true,
        method: "POST",
        data: {
          'page': page,
          'limit': limit,
          "type": type,
          'is_new': type != 'search',
          "filter": {
            "avatar": filter.avatar,
            "province":
                filter.province == null ? null : int.parse(filter.province!),
            "city": filter.city == null ? null : int.parse(filter.city!),
            "minAge": int.parse(filter.minAge ?? '0'),
            "maxAge": int.parse(filter.maxAge ?? '100'),
            "marital":
                filter.marital == null ? null : int.parse(filter.marital!),
          },
        },
      );

      if (result['status']) {
        return ApiUserSearchResponseModel(
          lastPage: result['result']['meta']['totalPages'],
          profiles: List.from(result['result']['data'])
              .map(
                (e) => ProfileSearchModel(
                  id: e['id'].toString(),
                  seen: e['online'].toString().toLowerCase(),
                  avatar: e['avatar'],
                  fullname: e['name'],
                  city: e['city'],
                  ad: e['advertised'],
                  special: e['vip'],
                  verified: e['blue_verify'],
                  age: e['age'],
                  relationCount: e['reactions_count'] == null
                      ? RelationCount(likes: 0, dislikes: 0)
                      : RelationCount(
                          likes: e['reactions_count']['likes'],
                          dislikes: e['reactions_count']['dislikes'],
                        ),
                ),
              )
              .toList(),
        );
      }

      return ApiUserSearchResponseModel.empty;
    } on DioException catch (e) {
      print(e.response);

      return ApiUserSearchResponseModel.empty;
    }
  }

  @override
  Future<ProfileModel?> one({required String id}) async {
    if (id.isEmpty) return null;

    try {
      var result = await http.request(
        path: '/api/v1/profile',
        auth: true,
        method: "POST",
        data: {
          "id": id,
          "detailed": true,
        },
      );

      if (result['status'] == true) {
        var profile = fromJsonToProfile(result['result']);

        return profile;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<ApiUserUpdateResponseModel> update(ProfileModel profile) async {
    try {
      var result = await http.request(
        path: '/api/v1/update-me',
        method: "POST",
        auth: true,
        data: {
          "name": profile.fullname,
          "year": profile.dropdowns!['year'],
          "month": profile.dropdowns!['month'],
          "day": profile.dropdowns!['day'],
          "marital": profile.dropdowns!['marital'],
          "children": profile.dropdowns!['children'],
          "maxAge": profile.dropdowns!['maxAge'],
          "height": profile.dropdowns!['height'],
          "weight": profile.dropdowns!['weight'],
          "color": profile.dropdowns!['color'],
          "shape": profile.dropdowns!['shape'],
          "beauty": profile.dropdowns!['beauty'],
          "health": profile.dropdowns!['health'],
          "education": profile.dropdowns!['education'],
          "living": profile.dropdowns!['living'],
          "salary": profile.dropdowns!['salary'],
          "car": profile.dropdowns!['car'],
          "home": profile.dropdowns!['home'],
          "province": profile.dropdowns!['province'],
          "city": profile.dropdowns!['city'],
          "religion": profile.dropdowns!['religion'],
          "marriageType": profile.dropdowns!['marriageType'],
          "job": profile.dropdowns!['job'],
          "about": profile.dropdowns!['about'],
        },
      );

      return ApiUserUpdateResponseModel(
        success: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiUserUpdateResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiUploadResponseModel> changeAvatar({
    required File file,
    required Function(int precent) callback,
  }) async {
    try {
      var result = await http.upload(
        path: '/upload/profile-photo',
        file: file,
        callback: ({int percent = 0, int total = 0, int sent = 0}) {
          callback(percent);
        },
      );

      return ApiUploadResponseModel(
        success: result['status'],
        message: result['message'],
        url: result['current_path'],
        fileId: '',
      );
    } on DioException catch (e) {
      print(e.response);

      return ApiUploadResponseModel.unhandledError;
    }
  }

  @override
  Future<bool> deleteAvatar() async {
    try {
      var result = await http.request(
        path: '/api/v1/delete-profile-photo',
        method: "DELETE",
        auth: true,
      );

      return result['status'];
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiUserOTPRequestResponseModel> requestOTP({
    required String sign,
  }) async {
    try {
      var result = await http.request(
        method: 'POST',
        path: '/api/v1/get-otp',
        auth: true,
        data: {
          'sign': sign,
        },
      );

      var ttl = result['result']['ttl'] as int;
      var end =
          DateTime.parse(result['result']['expire_at']).millisecondsSinceEpoch;

      return ApiUserOTPRequestResponseModel(
        ttl: ttl,
        end: end,
        message: result['message'],
      );
    } catch (e) {
      return ApiUserOTPRequestResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiUserOTPVerifyResponseModel> verifyOTP({
    required String code,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/verify-otp',
        method: "POST",
        auth: true,
        data: {
          'otp': code,
        },
      );

      return ApiUserOTPVerifyResponseModel(
        success: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiUserOTPVerifyResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiUserChangeResponseModel> changePassword({
    required String password,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/update-password',
        method: "POST",
        auth: true,
        data: {"password": password},
      );

      return ApiUserChangeResponseModel(
        success: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiUserChangeResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiUserChangeResponseModel> changePhone({
    required String phone,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/update-phone',
        method: "POST",
        auth: true,
        data: {"phone": phone},
      );

      return ApiUserChangeResponseModel(
        success: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiUserChangeResponseModel.unhandledError;
    }
  }

  @override
  Future<bool> changeSettings(ApiUserChangeSettingsRequestModel request) async {
    try {
      var result = await http.request(
        path: '/api/v1/update-settings',
        method: "POST",
        auth: true,
        data: {
          'allowVoiceCall': request.voiceCall,
          'allowVideoCall': request.videoCall,
          'notificationReaction': request.notificationReaction,
          'notificationChat': request.notificationChat,
          'notificationVoiceCall': request.notificationVoiceCall,
          'notificationVideoCall': request.notificationVideoCall,
        },
      );

      return result['status'];
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> react({
    required String user,
    required RELATION_ACTION action,
  }) async {
    try {
      // ignore: prefer_typing_uninitialized_variables
      var result;

      switch (action) {
        case RELATION_ACTION.BLOCK:
          result = await http.request(
            path: '/api/v1/do-interaction',
            method: "POST",
            auth: true,
            data: {"entity_id": user, "type": "block"},
          );
          break;
        case RELATION_ACTION.UNBLOCK:
          result = await http.request(
            path: '/api/v1/undo-interaction',
            method: "POST",
            auth: true,
            data: {"entity_id": user, "type": "block"},
          );
          break;
        // favorite
        case RELATION_ACTION.FAVORITE:
          result = await http.request(
            path: '/api/v1/do-interaction',
            method: "POST",
            auth: true,
            data: {"entity_id": user, "type": "fave"},
          );
          break;
        // disfavorite
        case RELATION_ACTION.DISFAVORITE:
          result = await http.request(
            path: '/api/v1/undo-interaction',
            method: "POST",
            auth: true,
            data: {"entity_id": user, "type": "fave"},
          );
          break;
        // like
        case RELATION_ACTION.LIKE:
          result = await http.request(
            path: '/api/v1/do-interaction',
            method: "POST",
            auth: true,
            data: {"entity_id": user, "type": "like"},
          );
          break;
        // dislike
        case RELATION_ACTION.DISLIKE:
          result = await http.request(
            path: '/api/v1/do-interaction',
            method: "POST",
            auth: true,
            data: {"entity_id": user, "type": "dislike"},
          );
          break;
        default:
      }

      return result['status'];
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiUserSearchResponseModel> reacts({
    required int page,
    required RELATION_ACTION action,
    int limit = 12,
  }) async {
    try {
      var type = {
        RELATION_ACTION.BLOCK: 'blocks',
        RELATION_ACTION.FAVORITE: 'faves',
        RELATION_ACTION.BLOCKED: 'blocked',
        RELATION_ACTION.FAVORITED: 'faved',
        RELATION_ACTION.VISIT: 'visits',
        RELATION_ACTION.VISITED: 'visited'
      }[action];

      var result = await http.request(
        path: '/api/v1/interactions',
        method: "POST",
        auth: true,
        data: {
          "limit": limit,
          "page": page,
          "type": type,
        },
      );

      if (result['status']) {
        return ApiUserSearchResponseModel(
          lastPage: result['result']['meta']['totalPages'],
          profiles: List.from(result['result']['data'])
              .map(
                (e) => ProfileSearchModel(
                  id: e['id'].toString(),
                  seen: e['online'].toString().toLowerCase(),
                  avatar: e['avatar'],
                  fullname: e['name'],
                  city: e['city'],
                  ad: e['advertised'],
                  special: e['vip'],
                  verified: e['blue_verify'],
                  age: e['age'],
                  relationCount: e['reactions_count'] == null
                      ? RelationCount(likes: 0, dislikes: 0)
                      : RelationCount(
                          likes: e['reactions_count']['likes'],
                          dislikes: e['reactions_count']['dislikes'],
                        ),
                ),
              )
              .toList(),
        );
      }

      return ApiUserSearchResponseModel.empty;
    } catch (e) {
      print(e);
      return ApiUserSearchResponseModel.empty;
    }
  }

  @override
  Future<bool> disable(
      {required String type, required String description}) async {
    try {
      var result = await http.request(
        path: '/api/v1/disable-account',
        method: "POST",
        auth: true,
        data: {
          "type": type == 'delete' ? 'LEFT_FOR_EVER' : 'UNSUBSCRIBE',
          "description": description,
        },
      );

      return result['status'];
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiSimpleResponseModel> sendFreeMessage({
    required String user,
    required String message,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/do-interaction',
        method: "POST",
        auth: true,
        data: {
          "entity_id": user,
          "dropdown_id": message,
          "type": "interest",
        },
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiSimpleResponseModel(
        status: false,
        message: 'خطایی رخ داد',
      );
    }
  }

  @override
  Future<ApiUserSendSMSResponseModel> sendSMS({required String user}) async {
    try {
      var result = await http.request(
        path: '/api/v1/do-interaction',
        method: "POST",
        auth: true,
        data: {"entity_id": user, "type": "invite"},
      );

      return ApiUserSendSMSResponseModel(
        status: result['status'],
        message: result['message'],
        remaining: result['status'] == true ? result['result']['sms'] : null,
      );
    } catch (e) {
      return ApiUserSendSMSResponseModel(
        status: false,
        message: 'خطایی رخ داد',
      );
    }
  }

  @override
  Future<ApiSimpleResponseModel> joinToNotification(
      {required String token}) async {
    try {
      var result = await http.request(
        path: '/api/v1/firebase/set-token',
        method: 'POST',
        data: {'token': token},
        auth: true,
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } on DioException catch (e) {
      print(e.response);

      return ApiSimpleResponseModel.unhandledError;
    }
  }

  @override
  Future<void> logout() async {
    return await http.request(path: '/api/v1/logout', auth: true);
  }
}
