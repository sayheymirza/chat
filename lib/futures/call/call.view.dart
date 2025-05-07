import 'package:chat/futures/call/call.controller.dart';
import 'package:chat/futures/call/participant.view.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'video.widget.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CallController());

    var url = 'https://livekit.catroom.ir';
    var token = Get.parameters['token'] ?? Get.arguments?['token'];

    var mode = Get.parameters['mode'] ?? Get.arguments?['mode'] ?? 'video';

    if (mode == "audio") {
      controller.microphone.value = true;
      controller.camera.value = false;
    } else {
      controller.microphone.value = true;
      controller.camera.value = true;
    }

    print('tring connect to ...');

    controller.connect(
      url: url,
      token: token,
    );

    return Obx(
      () => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Get.theme.primaryColor,
                      Get.theme.primaryColorDark,
                      Get.theme.primaryColorLight,
                    ],
                  ),
                ),
              ),
              if (controller.camera.value &&
                  controller.room.localParticipant != null)
                SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: VideoView(
                    participant: controller.room.localParticipant!,
                  ),
                ),
              // remote participant video small on top right
              Positioned(
                top: Get.mediaQuery.padding.top + 20,
                right: 20,
                child: Row(children: [
                  // ...controller.room.remoteParticipants.values
                  //     .map((_, participant) {
                  //   return ParticipantView(
                  //     participant: participant,
                  //   );
                  // }),

                  ...controller.room.remoteParticipants.values
                      .map((participant) {
                    return SizedBox(
                      width: 100,
                      height: 140,
                      child: ParticipantView(
                        participant: participant,
                      ),
                    );
                  }),
                ]),
              ),

              if (controller.profile.value.avatar != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 100,
                  child: AnimatedOpacity(
                    opacity: controller.profiling.value &&
                            controller.camera.value == false
                        ? 1
                        : 0,
                    duration: Duration(seconds: 1),
                    child: Column(
                      children: [
                        AvatarWidget(
                          seen: 'online',
                          url: controller.profile.value.avatar!,
                          size: 128,
                        ),
                        const Gap(20),
                        Text(
                          controller.profile.value.fullname!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          controller.time.value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 40,
                    right: 20,
                    left: 20,
                    top: 40,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white24,
                        Colors.white54,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      button(
                        onTap: () => controller.microphoneToggle(),
                        icon: controller.microphone.value
                            ? Icons.mic_rounded
                            : Icons.mic_off_rounded,
                        label: controller.microphone.value
                            ? "میکروفون روشن"
                            : "میکروفون خاموش",
                        backgroundColor: controller.microphone.value
                            ? Colors.green
                            : Colors.red,
                      ),
                      button(
                        onTap: () => controller.cameraToggle(),
                        icon: controller.camera.value
                            ? Icons.videocam_rounded
                            : Icons.videocam_off_rounded,
                        label: controller.camera.value
                            ? "دوربین روشن"
                            : "دوربین خاموش",
                        backgroundColor:
                            controller.camera.value ? Colors.green : Colors.red,
                      ),
                      button(
                        onTap: () => controller.hangup(),
                        icon: Icons.call_end_rounded,
                        label: "قطع تماس",
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button({
    required Function onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    Color iconColor = Colors.white,
    Color labelColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
            ),
            const Gap(12),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                  shadows: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black45,
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
