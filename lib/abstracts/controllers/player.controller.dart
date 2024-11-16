import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlayerController {
  RxBool playing = false.obs;
  late VideoPlayerController controller;

  RxString totalTime = '00:00'.obs;
  RxString passedTime = '00:00'.obs;

  Rx<Duration> totalDuration = Duration().obs;
  Rx<Duration> passedDuration = Duration().obs;

  Timer? timer;

  Future<void> load({
    required String url,
  }) async {
    if (url.startsWith('https')) {
      // @TODO: cache
    }

    log('[player.controller.dart] load $url');

    try {
      controller = VideoPlayerController.file(File(url));
      await controller.initialize();

      durationing();
    } catch (e) {
      log('[player.controller.dart] load failed $url');
      debugPrint(e.toString());
    }
  }

  void seek(Duration duration) async {
    await controller.seekTo(duration);
    durationing();
  }

  void toggle() {
    if (playing.value) {
      pause();
    } else {
      play();
    }
  }

  void play() async {
    await controller.play();

    playing.value = true;

    durationing();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      durationing();
    });
  }

  void pause() async {
    await controller.pause();

    playing.value = false;

    if (timer != null) {
      timer!.cancel();
    }
  }

  void durationing() async {
    String formatTime(Duration duration) {
      return duration.toString().split('.').first.replaceFirst('0:', '');
    }

    // init passed
    var position = (await controller.position) ?? Duration();
    passedTime.value = formatTime(position);
    passedDuration.value = position;
    // init total
    var total = controller.value.duration;
    totalTime.value = formatTime(total);
    totalDuration.value = total;

    // if end
    if (controller.value.isPlaying) {
      playing.value = true;
    } else {
      playing.value = false;

      if (timer != null) {
        timer!.cancel();
      }
    }
  }

  Widget buttonPlay({
    required bool playing,
    required Function onToggle,
    double size = 42,
    double radius = 14,
    Color? color,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        onToggle();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  Widget seeker({
    required double width,
    required Duration totalDuration,
    required Duration passedDuration,
    required Function(Duration) onSeek,
    Color? inactiveColor,
    Color? activeColor,
    List<dynamic> waveframe = const [],
  }) {
    return SizedBox(
      width: width,
      height: 30,
      child: Stack(
        children: [
          if (waveframe.isNotEmpty)
            SizedBox(
              width: width,
              height: 30,
              child: RectangleWaveform(
                samples:
                    waveframe.map((e) => double.parse(e.toString())).toList(),
                height: 30,
                width: width,
                maxDuration: totalDuration,
                elapsedDuration: passedDuration,
                inactiveColor: inactiveColor ?? Colors.grey.shade400,
                inactiveBorderColor: inactiveColor ?? Colors.grey.shade400,
                activeColor: activeColor ?? Get.theme.primaryColor,
                activeBorderColor: activeColor ?? Get.theme.primaryColor,
                borderWidth: 1,
                isRoundedRectangle: true,
                isCentered: true,
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Transform.flip(
              flipX: true,
              child: SizedBox(
                width: width,
                child: Opacity(
                  opacity: waveframe.isEmpty ? 1 : 0,
                  child: Slider(
                    min: 0,
                    max: totalDuration.inMilliseconds.toDouble(),
                    value: Math.min(
                      passedDuration.inMilliseconds.toDouble(),
                      totalDuration.inMilliseconds.toDouble(),
                    ),
                    onChanged: (value) {
                      var seconds = value.toInt();

                      onSeek(Duration(seconds: seconds));
                    },
                    thumbColor: activeColor ?? Get.theme.primaryColor,
                    activeColor: activeColor ?? Get.theme.primaryColor,
                    inactiveColor: inactiveColor ?? Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
