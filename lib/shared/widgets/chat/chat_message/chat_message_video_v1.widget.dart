import 'package:chat/abstracts/controllers/player.controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player_control_panel/video_player_control_panel.dart';

class ChatMessageVideoV1Widget extends StatelessWidget {
  final String url;
  final int size;
  final int duration;

  const ChatMessageVideoV1Widget({
    super.key,
    required this.url,
    required this.size,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    var controller = ChatMessageVoiceV1Controller();

    controller.load(url: url);

    return controller.controller == null
        ? Container()
        : Container(
            width: 300,
            height: 300,
            padding: EdgeInsets.all(0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: JkVideoControlPanel(
              controller.controller,
              showClosedCaptionButton: false,
              showVolumeButton: true,
            ),
          );
  }
}

class ChatMessageVoiceV1Controller extends PlayerController {}
