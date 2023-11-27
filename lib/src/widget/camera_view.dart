import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/agora_user.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    super.key,
    required this.rtcEngine,
    required this.channelName,
    required this.displayName,
    required this.agoraUser,
    required this.isLocal,
    this.isMostActive = false,
    this.width = 120.0,
    this.height = 160.0,
    this.backgroundColor,
  });

  final RtcEngine rtcEngine;
  final String channelName;
  final String displayName;
  final AgoraUser agoraUser;
  final bool isLocal;
  final bool isMostActive;
  final double width;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border:
            isMostActive ? Border.all(width: 1.0, color: Colors.green) : null,
        color:
            backgroundColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: !agoraUser.isCameraOn
                  ? CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Center(child: Text(displayName)),
                    )
                  : isLocal
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: rtcEngine,
                            canvas: const VideoCanvas(uid: 0),
                            useFlutterTexture: true,
                          ),
                          onAgoraVideoViewCreated: (_) =>
                              rtcEngine.startPreview(),
                        )
                      : AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: rtcEngine,
                            canvas: VideoCanvas(uid: agoraUser.id),
                            connection: RtcConnection(channelId: channelName),
                            useFlutterTexture: true,
                          ),
                        ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Icon(
              agoraUser.isMicroOn ? Icons.mic : Icons.mic_off,
              color: agoraUser.isMicroOn ? Colors.white : Colors.red,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
