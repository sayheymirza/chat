import 'package:chat/shared/color.dart';
import 'package:chat/shared/widgets/chat/chat_attachment/chat_attachment.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatAttachmentView extends GetView<ChatAttachmentController> {
  const ChatAttachmentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatAttachmentController());

    return Container(
      height: 140,
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
        button(
          color: HexColor("3B81F6"),
          icon: Icons.collections,
          label: "گالری",
          onTap: () {
            controller.imageFromGallery();
          },
        ),
        // button دوربین
        button(
          color: HexColor("EC4899"),
          icon: Icons.camera_alt,
          label: "دوربین",
          onTap: () {
            controller.imageFromCamera();
          },
        ),
        // button موزیک
        button(
          color: HexColor("F43F5E"),
          icon: Icons.headset,
          label: "موزیک",
          onTap: () {
            controller.pickAudio();
          },
        ),
        // button فیلم
        button(
          color: HexColor("A854F7"),
          icon: Icons.movie,
          label: "فیلم",
          onTap: () {
            controller.pickVideo();
          },
        ),
        // button لوکیشن
        button(
          color: HexColor("16A349"),
          icon: Icons.location_on,
          label: "نقشه",
          onTap: () {
            controller.pickMap();
          },
        ),
      ],
    );
  }

  Widget button({
    required Color color,
    required IconData icon,
    required String label,
    required Function() onTap,
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
