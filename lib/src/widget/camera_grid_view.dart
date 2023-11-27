import 'dart:collection';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/camera_view.dart';

class CameraGridView extends StatefulWidget {
  const CameraGridView({
    super.key,
    required this.rtcEngine,
    required this.channelName,
    required this.ownUser,
    required this.users,
    required this.agoraOwnUser,
    required this.agoraUsers,
    required this.boxConstraints,
  });

  final RtcEngine rtcEngine;
  final String channelName;
  final User? ownUser;
  final UnmodifiableMapView<int, User> users;
  final AgoraUser agoraOwnUser;
  final UnmodifiableListView<AgoraUser> agoraUsers;
  final BoxConstraints boxConstraints;

  @override
  State<CameraGridView> createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  final ownCameraPosition = ValueNotifier<(double, double)>((0.0, 0.0));
  final cameraWidth = 120.0;
  final cameraHeight = 160.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ownCameraPosition.value = (
        widget.boxConstraints.maxWidth - cameraWidth,
        widget.boxConstraints.maxHeight - cameraHeight
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemBuilder: (context, index) {
              final agoraUser = widget.agoraUsers[index];
              final user = widget.users[agoraUser.id];
              return CameraView(
                rtcEngine: widget.rtcEngine,
                channelName: widget.channelName,
                displayName: AppUtils.getDisplayUserName(user),
                agoraUser: agoraUser,
                isLocal: false,
                backgroundColor: Colors.grey,
              );
            },
            itemCount: widget.agoraUsers.length,
          ),
        ),
        ValueListenableBuilder<(double, double)>(
          valueListenable: ownCameraPosition,
          builder: (context, position, child) => Positioned(
            left: position.$1,
            top: position.$2,
            child: child!,
          ),
          child: GestureDetector(
            onPanUpdate: (details) =>
                _onPanUpdate(details, widget.boxConstraints),
            child: CameraView(
              rtcEngine: widget.rtcEngine,
              channelName: widget.channelName,
              displayName: AppUtils.getDisplayUserName(widget.ownUser),
              agoraUser: widget.agoraOwnUser,
              isLocal: true,
              backgroundColor: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    double left = min(
      constraints.maxWidth - cameraWidth,
      max(
        0.0,
        details.delta.dx + ownCameraPosition.value.$1,
      ),
    );
    double top = min(
      constraints.maxHeight - cameraHeight,
      max(
        0.0,
        details.delta.dy + ownCameraPosition.value.$2,
      ),
    );
    ownCameraPosition.value = (left, top);
  }
}
