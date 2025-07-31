import 'package:chat/shared/color.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:chat/shared/widgets/chat/chat_attachment/chat_attachment.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatAttachmentView extends GetView<ChatAttachmentController> {
  final List<String> permissions;

  const ChatAttachmentView({
    super.key,
    this.permissions = const [],
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ChatAttachmentController());

    return Container(
      height: 130 + navigationBarHeight,
      padding: EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: buttons(),
    );
  }

  Widget buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (permissions.contains('CAN_PICK_GALLERY'))
          button(
            color: HexColor("3B81F6"),
            icon: Icons.collections,
            label: "گالری",
            onTap: permissions.contains('CAN_PICK_GALLERY_WORK')
                ? () {
                    controller.imageFromGallery();
                  }
                : null,
          ),
        // button دوربین
        if (permissions.contains('CAN_PICK_CAMERA'))
          button(
            color: HexColor("EC4899"),
            icon: Icons.camera_alt,
            label: "دوربین",
            onTap: permissions.contains('CAN_PICK_CAMERA_WORK')
                ? () {
                    controller.imageFromCamera();
                  }
                : null,
          ),
        // button موزیک
        if (permissions.contains('CAN_PICK_AUDIO'))
          button(
            color: HexColor("F43F5E"),
            icon: Icons.headset,
            label: "موزیک",
            onTap: permissions.contains('CAN_PICK_AUDIO_WORK')
                ? () {
                    controller.pickAudio();
                  }
                : null,
          ),
        // button فیلم
        if (permissions.contains('CAN_PICK_VIDEO'))
          button(
            color: HexColor("A854F7"),
            icon: Icons.movie,
            label: "فیلم",
            onTap: permissions.contains('CAN_PICK_VIDEO_WORK')
                ? () {
                    controller.pickVideo();
                  }
                : null,
          ),
        // button لوکیشن
        if (permissions.contains('CAN_PICK_LOCATION'))
          button(
            color: HexColor("16A349"),
            icon: Icons.location_on,
            label: "نقشه",
            onTap: permissions.contains('CAN_PICK_LOCATION_WORK')
                ? () {
                    controller.pickMap();
                  }
                : null,
          ),
      ],
    );
  }

  Widget button({
    required Color color,
    required IconData icon,
    required String label,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 4,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Gap(16),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
