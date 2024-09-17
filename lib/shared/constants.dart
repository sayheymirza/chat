import 'package:flutter_dotenv/flutter_dotenv.dart';

class CONSTANTS {
  static String DEFAULT_ENDPOINT_API = "";

  static String STORAGE_ENDPOINT_API = "endpoint:api";
  static String STORAGE_ACCESS_TOKEN = "app:access_token";

  static String STORAGE_SETTINGS_SOUND_CHAT = "settings:sound_chat";
  static String STORAGE_SETTINGS_SOUND_CALL = "settings:sound_call";
  static String STORAGE_SETTINGS_VIBRATION = "settings:vibration";

  static String STORAGE_CARD_BANK = "card:bank";
  static String STORAGE_CARD_NUMBER = "card:number";
  static String STORAGE_CARD_NAME = "card:name";
  static String STORAGE_CARD_COLOR = "card:color";

  static String STROAGE_PLANS = 'app:plans';

  static Future<void> Load() async {
    await dotenv.load(fileName: "lib/app/app.env");

    CONSTANTS.DEFAULT_ENDPOINT_API = dotenv.env['DEFAULT_ENDPOINT_API']!;
  }
}
