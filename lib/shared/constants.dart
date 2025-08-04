import 'package:flutter/material.dart';

class CONSTANTS {
  static String DEFAULT_ENDPOINT_API = "";
  static String DEFAULT_ENDPOINT_SOCKET = "";

  static String CURRENT_CHAT = "chat:id";

  static String STORAGE_PROFILE = 'profile';

  static String STORAGE_ENDPOINT_API = "endpoint:api";
  static String STORAGE_ENDPOINT_SOCKET = "endpoint:socket";
  static String STORAGE_ACCESS_TOKEN = "app:access_token";

  static String STORAGE_SETTINGS_SOUND_CHAT = "settings:sound_chat";
  static String STORAGE_SETTINGS_SOUND_CALL = "settings:sound_call";
  static String STORAGE_SETTINGS_VIBRATION = "settings:vibration";

  static String STORAGE_LIVEKIT_URL = "livekit:url";
  static String STORAGE_LIVEKIT_HEARTBEAT = "livekit:heartbeat";

  static String STORAGE_MAP_TYPE = "map:type";
  static String STORAGE_MAP_URL = "map:url";
  static String STORAGE_MAP_LAT = "map:lat";
  static String STORAGE_MAP_LON = "map:lon";
  static String STORAGE_MAP_ZOOM = "map:zoom";

  static String STORAGE_CARD_BANK = "card:bank";
  static String STORAGE_CARD_NUMBER = "card:number";
  static String STORAGE_CARD_NAME = "card:name";
  static String STORAGE_CARD_COLOR = "card:color";

  static String STORAGE_PAGE_TERMS = 'page:terms';
  static String STORAGE_PAGE_PRIVACY = 'page:privacy';
  static String STORAGE_PAGE_PLANS_HELP = 'page:plans';

  static String STORAGE_CONTACT_US_FORM = 'contact_us:form';
  static String STORAGE_CONTACT_US_TIME = 'contact_us:response_time';
  static String STORAGE_CONTACT_US_PHONE = 'contact_us:phone';
  static String STORAGE_CONTACT_US_EMAIL = 'contact_us:email';
  static String STORAGE_CONTACT_US_ADDRESS = 'contact_us:address';
  static String STORAGE_CONTACT_US_PHONE_DESCRIPTION =
      'contact_us:phone_description';
  static String STORAGE_CONTACT_US_PHONE_PLATFORMS =
      'contact_us:phone_plafroms';
  static String STORAGE_CONTACT_US_EMAIL_DESCRIPTION =
      'contact_us:email_description';
  static String STORAGE_CONTACT_US_ADDRESS_DESCRIPTION =
      'contact_us:address_description';
  static String STORAGE_CONTACT_US_CHANNELS = 'contact_us:channels';

  static String STROAGE_PLANS = 'app:plans';

  static String STORAGE_LINK_WEBSITE = 'link:website';
  static String STORAGE_LINK_WEBLOG = 'link:weblog';
  static String STORAGE_LINK_DOWNLOAD = 'link:download';

  static String STORAGE_TEXT_EARNING_INCOME = 'text:earning_income';

  static String STORAGE_LATEST_VERSION = 'version:latest';
  static String STORAGE_DEPRECATED_VERSION = 'version:deprecated';

  static String STORAGE_VERIFY_PHONE_DESCRIPTION =
      'app:verify_phone_description';

  static String STORAGE_EYE_TIME = 'app:eye_time';

  static String STORAGE_INVITE_LINK = 'app:invite_link';

  static String STORAGE_FIREBASE_TOKEN = 'firebase:token';

  static String PAYMENT_CALLBACK = '';
  static String FLAVOR = '';

  static String CAFEBAZAAR_RSA = "app:cafebazaar-rsa";
  static String MYKET_RSA = "app:myket-rsa";

  static String AUDIO_BEEP_BEEP = "audio:beep_beep";
  static String AUDIO_DIALING = "audio:dialing";
  static String AUDIO_MESSAGE = "audio:message_incoming";
  static String AUDIO_RINGTONE = "audio:ringtone";

  static String CALL_INCALL = "call:incall";
  static String CALL_INCOMMING = "call:incoming";

  static List<Map<String, dynamic>> PAYMENT_METHODS = [
    {
      'key': 'psp',
      'text': 'پرداخت آنلاین',
      'icon': Icons.language,
    },
    {
      'key': 'card-by-card',
      'text': 'کارت به کارت',
      'icon': Icons.payments,
    },
    {'key': 'cafebazaar', 'text': 'کافه بازار', 'image': 'cafebazaar'}
  ];

  static Future<void> Load() async {}

  static Map<String, String> get PAYMENT_METHODS_MAP {
    Map<String, String> output = {};

    for (var element in PAYMENT_METHODS) {
      output[element['key']] = element['text'];
    }

    return output;
  }
}
