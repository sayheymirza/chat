import 'dart:async';
import 'dart:developer';

import 'package:chat/models/chat/chat.message.audio.v1.dart';
import 'package:chat/models/chat/chat.message.image.v1.dart';
import 'package:chat/models/chat/chat.message.map.v1.dart';
import 'package:chat/models/chat/chat.message.text.v1.dart';
import 'package:chat/models/chat/chat.message.video.v1.dart';
import 'package:chat/models/chat/chat.message.voice.v1.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/vibration.dart';
import 'package:chat/shared/widgets/chat/chat_attachment/chat_attachment.view.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatFooterController extends GetxController {
  RxBool visableSendButton = false.obs;
  RxBool visableVoiceButton = true.obs;
  RxBool visableAttachmentButton = true.obs;
  RxBool visableEmojis = false.obs;

  String messageText = '';
  EmojiTextEditingController messageController = EmojiTextEditingController(
    emojiTextStyle: DefaultEmojiTextStyle.copyWith(
      fontFamily: "NotoColorEmoji",
    ),
  );
  FocusNode messageFocus = FocusNode();

  AudioRecorder record = AudioRecorder();
  RxBool recoring = false.obs;
  RxString recordingDuration = '00:00'.obs;
  Timer? recordingInterval;

  void init() {
    visableSendButton.value = false;
    visableVoiceButton.value = true;
    visableAttachmentButton.value = true;
    messageController.clear();
  }

  // Function to perform the test with timeout
  Future<void> testSendMessages(int times, Duration delay) async {
    for (int i = 0; i < times; i++) {
      messageText = 'Message #${i + 1}';
      sendTextMessage();
      await Future.delayed(delay); // Add delay before the next message
    }
  }

  void sendTextMessage() {
    if (messageText.trim().isEmpty) return;

    Services.message
        .save(
      message: ChatMessageTextV1Model(text: messageText),
    )
        .then((_) {
      changeMessageText('');
      cancelRecoring();
    });
  }

  void changeMessageText(String value) {
    messageText = value;

    if (value.isEmpty) {
      init();
    } else {
      visableSendButton.value = true;
      visableVoiceButton.value = false;
      visableAttachmentButton.value = false;

      Services.chat.action(type: 'typing');
    }
  }

  void changeMessageTextFromController() {
    changeMessageText(messageController.text);
  }

  void toggleVisableEmojis() {
    visableEmojis.value = !visableEmojis.value;
    log('[chat_footer.controller.dart] visible emojis is ${visableEmojis.value}');
    if (visableEmojis.value) {
      messageFocus.unfocus();
    } else {
      messageFocus.requestFocus();
    }
  }

  void openAttachment({
    required List<String> permissions,
  }) {
    Get.bottomSheet(
      ChatAttachmentView(
        permissions: permissions,
      ),
      isScrollControlled: true,
    ).then((value) {
      // NavigationPopDialog();
      if (value != null) {
        print(value);
        switch (value['action']) {
          case 'audio':
            Services.message.save(
              message: ChatMessageAudioV1Model(
                sentAt: DateTime.now(),
                name: value['name'],
                duration: value['duration'],
                size: value['size'],
                url: value['path'],
              ),
            );
            break;
          case 'video':
            Services.message.save(
              message: ChatMessageVideoV1Model(
                sentAt: DateTime.now(),
                name: value['name'],
                duration: value['duration'],
                size: value['size'],
                url: value['path'],
              ),
            );
            break;
          case 'map':
            Services.message.save(
              message: ChatMessageMapV1Model(
                sentAt: DateTime.now(),
                lat: value['value']['lat'],
                lon: value['value']['lon'],
                zoom: value['value']['zoom'],
                url: value['value']['path'],
              ),
            );
            break;
          case 'image':
            Services.message.save(
              message: ChatMessageImageV1Model(
                sentAt: DateTime.now(),
                url: value['path'],
                size: value['size'] ?? 0,
              ),
            );
            break;
          default:
        }
      }
    });
  }

  void startRecordingDuration() {
    DateTime time = DateTime(200, 1, 1, 0, 0, 0);

    recordingDuration.value = '00:00';

    recordingInterval = Timer.periodic(const Duration(seconds: 1), (_) {
      time = time.add(const Duration(seconds: 1));

      var second = time.second.toString();
      var minute = time.minute.toString();

      second = second.length == 1 ? '0$second' : second;
      minute = minute.length == 1 ? '0$minute' : minute;

      recordingDuration.value = '$minute:$second';
    });
  }

  Future<void> startRecording() async {
    try {
      if (recoring.value == true) return;

      if (await record.hasPermission() && visableVoiceButton.value) {
        startRecordingDuration();

        var output = '';

        if (!kIsWeb) {
          var tempDir = await getTemporaryDirectory();

          output =
              '${tempDir.path}/record-${DateTime.now().millisecondsSinceEpoch}.opus';
        }

        await record.start(
          const RecordConfig(
            encoder: AudioEncoder.opus,
            bitRate: 128000,
            sampleRate: 44100,
            numChannels: 1,
          ),
          path: output,
        );
        // }

        recoring.value = true;
      } else {
        showSnackbar(message: 'دسترسی به میکروفون نداریم');

        stopRecording();
      }
    } catch (e) {
      print('error on start recording: $e');
      print(e);
    }
  }

  Future<void> stopRecording() async {
    try {
      if (recordingInterval != null) {
        recordingInterval!.cancel();
      }

      if (recoring.value == false) return;

      String? path = await record.stop();

      if (path != null) {
        List<int> waveframe = [];

        var [minute, seconds] = recordingDuration.value.split(':');
        var duration = int.parse(minute) * 60 + int.parse(seconds);

        // if duration is less than 1 second
        if (duration < 1) {
          cancelRecoring();
          showSnackbar(message: 'ویس کوتاه است');
          return;
        }

        waveframe = await Services.waveframe.process(path: path);

        Services.message.save(
          message: ChatMessageVoiceV1Model(
            sentAt: DateTime.now(),
            duration: duration * 1000,
            size: 0,
            url: path,
            waveform: waveframe.map((e) => e.toDouble()).toList(),
          ),
        );
      }
      // after 1 seconds set recording to false
      await Future.delayed(const Duration(milliseconds: 300));

      recoring.value = false;
    } catch (e) {
      cancelRecoring();

      print('error on stop recording: $e');

      debugPrint(e.toString());
    }
  }

  Future<void> cancelRecoring() async {
    if (recordingInterval != null) {
      recordingInterval!.cancel();
    }

    if (await record.isRecording()) {
      vibrate();

      await record.cancel();
    }

    recoring.value = false;
  }

  Future<void> toggleRecording() async {
    if (recoring.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }
}
