import 'package:get/get.dart';

void NavigationToNamed(String path, {dynamic params}) {
  Get.toNamed(
    path,
    parameters: params,
    preventDuplicates: true,
  );
}
