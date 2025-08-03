import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

class VideoView extends StatefulWidget {
  final Participant participant;

  const VideoView({super.key, required this.participant});

  @override
  State<StatefulWidget> createState() {
    return _VideoViewState();
  }
}

class _VideoViewState extends State<VideoView> {
  TrackPublication? videoPub;

  @override
  void initState() {
    super.initState();

    print('hello video view');

    widget.participant.addListener(_onParticipantChanged);
    // trigger initial change
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    print('changed video view');

    oldWidget.participant.removeListener(_onParticipantChanged);
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
    super.didUpdateWidget(oldWidget);
  }

  void _onParticipantChanged() {
    try {
      var videoPublications = widget.participant.videoTrackPublications;

      print('Number of video publications: ${videoPublications.length}');

      var filteredVideos = videoPublications.where((pub) {
        print(
            'Track kind: ${pub.kind}, isScreenShare: ${pub.isScreenShare}, hasTrack: ${pub.track != null}');
        return pub.kind == TrackType.VIDEO &&
            !pub.isScreenShare &&
            pub.track != null;
      });

      setState(() {
        if (filteredVideos.isNotEmpty) {
          var publication = filteredVideos.first;
          print('Selected video track - muted: ${publication.muted}');
          videoPub = publication;
        } else {
          print('No suitable video track found');
          videoPub = null;
        }
      });
    } catch (e) {
      print('Error in _onParticipantChanged: $e');
      setState(() {
        videoPub = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var videoPub = this.videoPub;
    if (videoPub != null && videoPub.track != null) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: VideoTrackRenderer(
            videoPub.track as VideoTrack,
            fit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
          ),
        );
      } catch (e) {
        print('Error rendering video: $e');
        return Container(
          color: Colors.grey.shade800,
          child: const Center(
            child: Icon(Icons.videocam_off, color: Colors.white, size: 48),
          ),
        );
      }
    } else {
      return Container(
        color: Colors.grey.shade800,
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.white, size: 48),
        ),
      );
    }
  }
}
