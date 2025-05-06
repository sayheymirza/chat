import 'dart:io';

import 'package:chat/shared/widgets/chat/chat_attachment/io_cropper_file.dart'
    if (dart.web) 'package:chat/shared/widgets/chat/chat_attachment/web_cropper_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class ChatAttachmentController extends GetxController {
  void imageFromGallery() {
    image(source: ImageSource.gallery);
  }

  void imageFromCamera() {
    image(source: ImageSource.camera);
  }

  void pickAudio() {
    pick(formats: ['mp3'], type: 'audio');
  }

  void pickVideo() {
    pick(formats: ['mp4'], type: 'video');
  }

  void pickMap() {
    Get.toNamed(
      '/app/map',
      arguments: {
        'action': 'pick',
      },
    )!
        .then((value) {
      if (value != null) {
        Get.back(
          result: {
            "action": "map",
            "value": value,
          },
        );
      }
    });
  }

  void pick({
    required List<String> formats,
    required String type,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: formats,
        allowCompression: false,
      );

      if (result != null) {
        String path = getFilePath(result.files.first);

        var size = result.files.first.size;

        var data = {};

        if (type == "video" || type == "audio") {
          var controller = kIsWeb
              ? VideoPlayerController.networkUrl(Uri.parse(path))
              : VideoPlayerController.file(File(path));
          await controller.initialize();
          data['duration'] = controller.value.duration.inMilliseconds;
        }

        // pop it
        Get.back(
          result: {
            "action": type,
            "path": path,
            "size": size,
            "name": basename(path),
            ...data,
          },
        );
      }
    } catch (e) {
      print('[chat_attachment.controller.dart] error on pick:');
      print(e.toString());
    }
  }

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
            "action": 'image',
            "path": path,
            "size": kIsWeb ? null : File(path).statSync().size,
          },
        );
      }
    } catch (e) {
      print('[chat_attachment.controller.dart] error is:');
      print(e);
    }
  }
}
