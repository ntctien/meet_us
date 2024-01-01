import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/widget/camera_view.dart';

class PinCameraView extends StatelessWidget {
  const PinCameraView({
    super.key,
    required this.rtcEngine,
    required this.channelName,
    required this.pinnedUserId,
    required this.user,
    required this.agoraUser,
    required this.isLocal,
    required this.boxConstraints,
    required this.onPinIconTap,
  });

  final RtcEngine rtcEngine;
  final String channelName;
  final int? pinnedUserId;
  final User? user;
  final AgoraUser? agoraUser;
  final bool isLocal;
  final BoxConstraints boxConstraints;
  final Function() onPinIconTap;

  bool get _shrink => pinnedUserId == null || agoraUser == null;

  @override
  Widget build(BuildContext context) {
    if (_shrink) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: boxConstraints.maxWidth,
      height: boxConstraints.maxHeight,
      child: CameraView(
        key: Key('$pinnedUserId'),
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        rtcEngine: rtcEngine,
        channelName: channelName,
        user: user,
        agoraUser: agoraUser!,
        isLocal: isLocal,
        backgroundColor: Colors.grey,
        isUserSharesScreen: false,
        isPinned: true,
        onPinIconTap: onPinIconTap,
      ),
    );
  }
}
