import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DialogPickImageController extends GetxController {
  void image({
    required ImageSource source,
  }) async {
    try {
      XFile? file = await ImagePicker().pickImage(
        source: source,
      );

      if (file != null) {
        // open cropper
        String? path = await Get.toNamed<dynamic>(
          "/app/cropper",
          arguments: {"path": file.path},
        );

        // pop it
        if (path != null) {
          Get.back(
            result: {
              "action": 'file',
              "data": path,
            },
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
