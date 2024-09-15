import 'package:chat/models/apis/data.model.dart';
import 'package:chat/models/dropdown.model.dart';
import 'package:chat/models/home.model.dart';
import 'package:chat/shared/services/http.service.dart';
import 'package:get/get.dart';

abstract class ApiDataAbstract extends GetxService {
  HttpService get http => Get.find(tag: 'http');

  Future<List<DropdownModel>> dropdowns();

  Future<List<HomeComponentModel>> home();

  Future<ApiDataHandshakeResponseModel?> handshake();
}
