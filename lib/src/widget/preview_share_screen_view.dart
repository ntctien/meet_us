import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PreviewShareScreenView extends StatelessWidget {
  const PreviewShareScreenView({
    super.key,
    required this.rtcEngine,
    required this.isShareScreen,
    required this.boxConstraints,
  });

  final bool isShareScreen;
  final BoxConstraints boxConstraints;
  final RtcEngine rtcEngine;

  @override
  Widget build(BuildContext context) {
    if (!isShareScreen) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: boxConstraints.maxWidth,
      height: boxConstraints.maxHeight,
      child: Center(
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: rtcEngine,
            canvas: const VideoCanvas(
              uid: 0,
              sourceType: VideoSourceType.videoSourceScreenPrimary,
              renderMode: RenderModeType.renderModeFit,
            ),
            useAndroidSurfaceView:
                defaultTargetPlatform == TargetPlatform.android,
          ),
        ),
      ),
    );
  }
}
