import 'package:chat/abstracts/controllers/player.controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatMessageAudioV1Widget extends StatelessWidget {
  final String url;
  final int size;
  final int duration;

  const ChatMessageAudioV1Widget({
    super.key,
    required this.url,
    required this.size,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    var controller = ChatMessageVoiceV1Controller();

    controller.load(url: url);

    return Obx(
      () => Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // waveform widget or player
            SizedBox(
              width: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  controller.seeker(
                    width: 210,
                    totalDuration: controller.totalDuration.value,
                    passedDuration: controller.passedDuration.value,
                    onSeek: (duration) {
                      controller.seek(duration);
                    },
                    inactiveColor: Colors.white.withAlpha(128),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Text(
                      controller.passedTime.value == '00:00'
                          ? controller.totalTime.value
                          : controller.passedTime.value,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            controller.buttonPlay(
              playing: controller.playing.value,
              onToggle: () {
                controller.toggle();
              },
              radius: 10,
              color: Get.theme.primaryColor,
              iconColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageVoiceV1Controller extends PlayerController {}
