import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

class ParticipantView extends StatefulWidget {
  final Participant participant;

  const ParticipantView({super.key, required this.participant});

  @override
  State<StatefulWidget> createState() {
    return _ParticipantState();
  }
}

class _ParticipantState extends State<ParticipantView> {
  TrackPublication? videoPub;

  @override
  void initState() {
    super.initState();
    // When track subscriptions change, Participant notifies listeners
    // Uses the built-in ChangeNotifier API
    widget.participant.addListener(_onChange);
  }

  @override
  void dispose() {
    super.dispose();
    widget.participant.removeListener(_onChange);
  }

  void _onChange() {
    TrackPublication? pub;
    var visibleVideos = widget.participant.videoTrackPublications.where((pub) {
      return pub.kind == TrackType.VIDEO && pub.subscribed && !pub.muted;
    });
    if (visibleVideos.isNotEmpty) {
      pub = visibleVideos.first;
    }
    // setState will trigger a build
    setState(() {
      // Your updates here
      videoPub = pub;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Audio tracks are automatically played.
    var videoPub = this.videoPub;
    if (videoPub != null) {
      return VideoTrackRenderer(
        videoPub.track as VideoTrack,
        fit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      );
    } else {
      return Container(
        color: Colors.transparent,
      );
    }
  }
}
