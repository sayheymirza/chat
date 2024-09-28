import 'package:chat/futures/dialog_pick_image/dialog_pick_image.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DialogPickImageView extends GetView<DialogPickImageController> {
  final bool deletable;
  final bool editable;

  const DialogPickImageView({
    super.key,
    this.deletable = false,
    this.editable = true,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(DialogPickImageController());

    return Container(
      height: Get.mediaQuery.padding.bottom + (deletable ? 160 : 100) + 32,
      width: Get.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Column(
        children: [
          // pick from gallery
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("انتخاب از گالری"),
            onTap: () {
              controller.image(
                source: ImageSource.gallery,
                editable: editable,
              );
            },
          ),
          // pick from camera
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("گرفتن عکس"),
            onTap: () {
              controller.image(
                source: ImageSource.camera,
                editable: editable,
              );
            },
          ),
          if (deletable) const Divider(),
          if (deletable)
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text("حذف عکس"),
              onTap: () {
                Navigator.pop(context, {
                  "action": "delete",
                });
              },
            )
        ],
      ),
    );
  }
}
