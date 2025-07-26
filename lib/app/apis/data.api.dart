import 'dart:io';

import 'package:chat/abstracts/apis/data.abstract.dart';
import 'package:chat/models/apis/api.model.dart';
import 'package:chat/models/apis/data.model.dart';
import 'package:chat/models/dropdown.model.dart';
import 'package:chat/models/home.model.dart';
import 'package:chat/models/plan.model.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiData extends ApiDataAbstract {
  @override
  Future<List<DropdownModel>> dropdowns() async {
    try {
      var result = await http.request(
        path: '/api/v1/dropdowns',
      );

      if (result['status'] == true) {
        List<DropdownModel> list = (result['dropdowns'] as List)
            .map(
              (e) => DropdownModel(
                id: e['id'],
                name: e['name'],
                value: e['value'],
                groupKey: e['keyGroup'],
                orderIndex: e['order'],
                parentId: e['parentId'],
              ),
            )
            .toList();

        return list;
      }

      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<HomeComponentModel>> home() async {
    try {
      var result = await http.request(
        path: '/api/v1/home',
        auth: true,
      );

      if (result['status'] == true) {
        var components = result['result']['components'] as List;
        var output = <HomeComponentModel>[];

        // convert map to the model
        for (var component in components) {
          dynamic data;

          switch (component['type']) {
            case 'list-profile#1':
              data = HomeComponentListProfileV1Model(
                title: component['data']['title'],
                icon: component['data']['icon'],
                buttonText: component['data']['button-text'],
                buttonType: component['data']['button-type'],
                emptyText: component['data']['empty-text'],
                profiles: List.from(component['data']['profiles'])
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
              break;
            case 'card-dynamic#1':
              data = CardDynamicV1Model(
                gradientColors: component['data']['gradientColors'],
                title: component['data']['title'],
                titleColor: component['data']['titleColor'],
                subtitle: component['data']['subtitle'],
                subtitleColor: component['data']['subtitleColor'],
                buttonText: component['data']['buttonText'],
                buttonOnTap: component['data']['buttonOnTap'],
                buttonVisable: component['data']['buttonVisable'],
                closeable: component['data']['closeable'],
              );
              break;
            default:
          }

          output.add(
            HomeComponentModel(
              id: component['id'],
              component: component['component'],
              type: component['type'],
              data: data,
            ),
          );
        }

        return output;
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ApiDataHandshakeResponseModel?> handshake() async {
    try {
      var result = await http.request(
        path: '/api/v1/handshake',
        auth: true,
      );

      if (result['status']) {
        List<PlanModel> plans = (result['result']['market_products'] as List)
            .map(
              (e) => PlanModel(
                id: e['id'],
                title: e['title'],
                description: e['description'],
                sku: e['sku'],
                category: e['category'],
                discount: e['discount'],
                price: e['price'],
                finalPrice: e['final_price'],
                usableCount: e['usable_count'],
                usableDays: e['usable_days'],
              ),
            )
            .toList();

        return ApiDataHandshakeResponseModel(
          configs: {
            CONSTANTS.STORAGE_LIVEKIT_URL: result['result']['configs']['call']
                ['livekit_server'],
            CONSTANTS.STORAGE_MAP_TYPE: result['result']['configs']['map']
                ['type'],
            CONSTANTS.STORAGE_MAP_URL: result['result']['configs']['map']
                ['url'],
            CONSTANTS.STORAGE_MAP_LAT:
                result['result']['configs']['map']['lat'].toString(),
            CONSTANTS.STORAGE_MAP_LON:
                result['result']['configs']['map']['lon'].toString(),
            CONSTANTS.STORAGE_MAP_ZOOM:
                result['result']['configs']['map']['zoom'].toString(),
            CONSTANTS.STORAGE_CARD_BANK: result['result']['configs']
                ['card_bank'],
            CONSTANTS.STORAGE_CARD_COLOR: result['result']['configs']
                ['card_color'],
            CONSTANTS.STORAGE_CARD_NAME: result['result']['configs']
                ['card_name'],
            CONSTANTS.STORAGE_CARD_NUMBER: result['result']['configs']
                ['card_number'],
            CONSTANTS.STORAGE_PAGE_TERMS: result['result']['configs']
                ['terms_page'],
            CONSTANTS.STORAGE_PAGE_PRIVACY: result['result']['configs']
                ['privacy_page'],
            CONSTANTS.STORAGE_PAGE_PLANS_HELP: result['result']['configs']
                ['plan_help'],
            CONSTANTS.STORAGE_CONTACT_US_FORM: result['result']['configs']
                ['contact_us_available'],
            CONSTANTS.STORAGE_CONTACT_US_TIME: result['result']['configs']
                ['contact_us_response_time'],
            CONSTANTS.STORAGE_CONTACT_US_PHONE: result['result']['configs']
                ['contact_us_contact_number'],
            CONSTANTS.STORAGE_CONTACT_US_ADDRESS: result['result']['configs']
                ['contact_us_office_address'],
            CONSTANTS.STORAGE_CONTACT_US_EMAIL: result['result']['configs']
                ['contact_us_email_address'],
            CONSTANTS.STORAGE_CONTACT_US_PHONE_DESCRIPTION: result['result']
                ['configs']['contact_us_contact_number_description'],
            CONSTANTS.STORAGE_CONTACT_US_PHONE_PLATFORMS: result['result']
                ['configs']['contact_us_contact_number_supported_platforms'],
            CONSTANTS.STORAGE_CONTACT_US_EMAIL_DESCRIPTION: result['result']
                ['configs']['contact_us_email_address_description'],
            CONSTANTS.STORAGE_CONTACT_US_ADDRESS_DESCRIPTION: result['result']
                ['configs']['contact_us_office_address_description'],
            CONSTANTS.STORAGE_CONTACT_US_CHANNELS: result['result']['configs']
                ['channels'],
            CONSTANTS.STORAGE_LINK_WEBSITE: result['result']['configs']
                ['menu_web_link'],
            CONSTANTS.STORAGE_LINK_WEBLOG: result['result']['configs']
                ['menu_weblog_link'],
            CONSTANTS.STORAGE_TEXT_EARNING_INCOME: result['result']['configs']
                ['earning_income_text'],
            CONSTANTS.STORAGE_LATEST_VERSION: result['result']['configs']
                ['latest_release'],
            CONSTANTS.STORAGE_DEPRECATED_VERSION: result['result']['configs']
                ['depracted_versions'],
            CONSTANTS.STORAGE_VERIFY_PHONE_DESCRIPTION: result['result']
                ['configs']['verify_phone_description'],
            CONSTANTS.STORAGE_EYE_TIME: result['result']['configs']
                ['users_eye_time'],
            CONSTANTS.STORAGE_INVITE_LINK: result['result']['configs']
                ['invite_link'],
            CONSTANTS.AUDIO_BEEP_BEEP: result['result']['configs']['audios']
                ['beep_beep'],
            CONSTANTS.AUDIO_DIALING: result['result']['configs']['audios']
                ['dialing'],
            CONSTANTS.AUDIO_MESSAGE: result['result']['configs']['audios']
                ['message_incoming'],
            CONSTANTS.AUDIO_RINGTONE: result['result']['configs']['audios']
                ['ringtone'],
          },
          plans: plans,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiUploadResponseModel> upload({
    required File file,
    required Function({int percent, int total, int sent}) callback,
    CancelToken? cancelToken,
  }) async {
    try {
      var result = await http.upload(
        path: '/upload',
        file: file,
        callback: callback,
        cancelToken: cancelToken,
      );

      return ApiUploadResponseModel(
        success: result['status'],
        message: result['message'],
        url: result['current_path'],
        fileId: result['file']['file_id'],
      );
    } on DioException catch (e) {
      print('[api.data.dart] upload error:');
      print(e.response?.data);
      return ApiUploadResponseModel.unhandledError;
    } on Exception catch (e) {
      print(e);
      print('[api.data.dart] upload error:');
      return ApiUploadResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiSimpleResponseModel> contact({
    required String type,
    required String reciver,
    required String title,
    required String description,
    String? email,
    String? file,
    int? user,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/forms/contact-us',
        method: "POST",
        auth: true,
        data: {
          'type': type,
          'user_id': user,
          'to': reciver,
          'title': title,
          'description': description,
          'email': email,
          'file': file,
        },
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } catch (e) {
      print(e);

      return ApiSimpleResponseModel.unhandledError;
    }
  }

  @override
  Future<ApiSimpleResponseModel> feedback({
    required int score,
    required String description,
  }) async {
    try {
      var result = await http.request(
        path: '/api/v1/forms/submit-score',
        method: "POST",
        auth: true,
        data: {
          'score': score,
          'description': description,
        },
      );

      return ApiSimpleResponseModel(
        status: result['status'],
        message: result['message'],
      );
    } catch (e) {
      return ApiSimpleResponseModel.unhandledError;
    }
  }
}
