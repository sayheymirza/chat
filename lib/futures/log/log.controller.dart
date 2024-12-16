import 'package:get/get.dart';

class LogController extends GetxController {
  List<Map<String, String>> categories = [
    {
      'text': 'همه',
      'key': '',
    },
    // socket
    {
      'text': 'سوکت',
      'key': 'socket',
    },
  ];

  RxString category = ''.obs;
}
