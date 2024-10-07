import 'package:chat/shared/services/profile.service.dart';
import 'package:get/get.dart';

class DialogSendSMSController extends GetxController {
  ProfileService get profile => Get.find(tag: 'profile');
}
