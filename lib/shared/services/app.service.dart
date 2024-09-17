import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class AppService extends GetxService {
  Future<void> handshake() async {
    var result = await ApiService.data.handshake();

    if (result != null) {
      // store plans
      Services.configs.set(
        key: CONSTANTS.STROAGE_PLANS,
        value: result.plans.map((element) => element.toJson()).toList(),
      );
      // store each config
      Services.configs.setFromMap(result.configs);
    }
  }
}
