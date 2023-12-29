import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/widget/string_extensions.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.rtcEngine,
    required this.channelName,
    required this.displayName,
    required this.agoraUser,
    required this.isLocal,
    required this.isUserSharesScreen,
    required this.isPinned,
    this.width = 120.0,
    this.height = 160.0,
    this.backgroundColor,
    this.onPinIconTap,
  });

  final RtcEngine rtcEngine;
  final String channelName;
  final String displayName;
  final AgoraUser agoraUser;
  final bool isLocal;
  final bool isUserSharesScreen;
  final bool isPinned;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Function()? onPinIconTap;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final _togglePinIcon = ValueNotifier<bool>(false);
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onSurfaceTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: widget.agoraUser.isMicroOn
              ? Border.all(width: 2.0, color: Colors.greenAccent)
              : null,
          color: widget.backgroundColor ??
              Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        clipBehavior: Clip.hardEdge,
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: !widget.agoraUser.isCameraOn || widget.isUserSharesScreen
                    ? CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            widget.displayName != 'N/A'
                                ? widget.displayName[0].toUpperCase()
                                : widget.displayName,
                          ),
                        ),
                      )
                    : widget.isLocal
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: widget.rtcEngine,
                              canvas: const VideoCanvas(uid: 0),
                              useFlutterTexture: true,
                            ),
                            onAgoraVideoViewCreated: (_) =>
                                widget.rtcEngine.startPreview(),
                          )
                        : AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: widget.rtcEngine,
                              canvas: VideoCanvas(
                                uid: widget.agoraUser.id,
                                renderMode: RenderModeType.renderModeFit,
                              ),
                              connection:
                                  RtcConnection(channelId: widget.channelName),
                              useAndroidSurfaceView: defaultTargetPlatform ==
                                  TargetPlatform.android,
                            ),
                          ),
              ),
            ),
            Positioned(
              left: 8.0,
              bottom: 8.0,
              child: SizedBox(
                width: widget.width - 16.0,
                child: Text(
                  widget.displayName.useCorrectEllipsis(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: Icon(
                widget.agoraUser.isMicroOn ? Icons.mic : Icons.mic_off,
                color: widget.agoraUser.isMicroOn ? Colors.white : Colors.red,
                size: 16.0,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _togglePinIcon,
              builder: (context, visible, child) {
                if (!visible) {
                  return const SizedBox.shrink();
                }
                return child!;
              },
              child: Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: IconButton(
                      onPressed: _onPinTap,
                      icon: Icon(
                        widget.isPinned
                            ? Icons.location_off
                            : Icons.location_on,
                        color: widget.isPinned ? Colors.red : Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSurfaceTap() {
    _togglePinIcon.value = !_togglePinIcon.value;
    if (_togglePinIcon.value) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        _togglePinIcon.value = false;
        timer.cancel();
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _onPinTap() {
    _togglePinIcon.value = false;
    widget.onPinIconTap?.call();
  }
}
