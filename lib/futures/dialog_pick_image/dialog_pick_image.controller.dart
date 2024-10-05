import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DialogPickImageController extends GetxController {
  void image({
    required ImageSource source,
    bool editable = true,
  }) async {
    try {
      XFile? file = await ImagePicker().pickImage(
        source: source,
      );

      if (file != null) {
        var path = file.path;
        if (editable) {
          // open cropper
          path = await Get.toNamed<dynamic>(
            "/app/cropper",
            arguments: {"path": file.path},
          );
        }

        // pop it
        Get.back(
          result: {
            "action": 'file',
            "data": path,
          },
        );
      }
    } catch (e) {
      //
    }
  }
}
