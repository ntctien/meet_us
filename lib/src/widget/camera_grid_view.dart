import 'dart:collection';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/widget/camera_view.dart';
import 'package:meet_us/src/widget/pin_camera_view.dart';
import 'package:meet_us/src/widget/preview_share_screen_view.dart';
import 'package:provider/provider.dart';

class CameraGridView extends StatefulWidget {
  const CameraGridView({
    super.key,
    required this.rtcEngine,
    required this.channelName,
    required this.isShareScreen,
    required this.ownUser,
    required this.pinnedUserId,
    required this.users,
    required this.agoraOwnUser,
    required this.agoraUsers,
    required this.boxConstraints,
    required this.onPin,
    required this.onUnpin,
  });

  final RtcEngine rtcEngine;
  final String channelName;
  final User? ownUser;
  final bool isShareScreen;
  final int? pinnedUserId;
  final UnmodifiableMapView<int, User> users;
  final AgoraUser agoraOwnUser;
  final UnmodifiableMapView<int, AgoraUser> agoraUsers;
  final BoxConstraints boxConstraints;
  final Function(AgoraUser) onPin;
  final Function(AgoraUser) onUnpin;

  @override
  State<CameraGridView> createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  Orientation _orientation = Orientation.portrait;
  final _ownCameraPosition = ValueNotifier<(double, double)>((0.0, 0.0));
  final _cameraWidth = 120.0;
  final _cameraHeight = 160.0;
  final _agoraUserIds = <int>{};

  @override
  void initState() {
    super.initState();
    _ownCameraPosition.value = (
      widget.boxConstraints.maxWidth - _cameraWidth,
      widget.boxConstraints.maxHeight - _cameraHeight
    );
    _agoraUserIds.addAll(widget.agoraUsers.keys);
    if (widget.pinnedUserId != null) {
      _agoraUserIds.remove(widget.pinnedUserId);
    }
  }

  @override
  void didUpdateWidget(covariant CameraGridView oldWidget) {
    final orientation = MediaQuery.orientationOf(context);
    if (_orientation != orientation) {
      _orientation = orientation;
      _ownCameraPosition.value = (
        widget.boxConstraints.maxWidth - _cameraWidth,
        widget.boxConstraints.maxHeight - _cameraHeight
      );
    } else if (widget.boxConstraints != oldWidget.boxConstraints) {
      final difWidth =
          widget.boxConstraints.maxWidth - oldWidget.boxConstraints.maxWidth;
      final difHeight =
          widget.boxConstraints.maxHeight - oldWidget.boxConstraints.maxHeight;
      _ownCameraPosition.value = (
        _ownCameraPosition.value.$1 + difWidth,
        _ownCameraPosition.value.$2 + difHeight
      );
    }
    _agoraUserIds.clear();
    _agoraUserIds.addAll(widget.agoraUsers.keys);
    if (widget.pinnedUserId != oldWidget.pinnedUserId &&
        widget.pinnedUserId != null) {
      _agoraUserIds.remove(widget.pinnedUserId);
    }
    final setA = Set.from(oldWidget.agoraUsers.keys);
    final setB = Set.from(widget.agoraUsers.keys);
    final differentValues = setB.difference(setA);
    if (differentValues.isNotEmpty) {
      final userState = context.read<UsersState>();
      for (final id in differentValues) {
        if (userState.users[id] == null) {
          userState.getUserInfoById(id);
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PreviewShareScreenView(
              rtcEngine: widget.rtcEngine,
              isShareScreen: widget.isShareScreen,
              boxConstraints: widget.boxConstraints,
            ),
            PinCameraView(
              rtcEngine: widget.rtcEngine,
              channelName: widget.channelName,
              pinnedUserId: widget.pinnedUserId,
              user: widget.users[widget.pinnedUserId],
              agoraUser: widget.agoraUsers[widget.pinnedUserId],
              isLocal: widget.pinnedUserId == widget.agoraOwnUser.id,
              boxConstraints: widget.boxConstraints,
              onPinIconTap: () =>
                  widget.onUnpin.call(widget.agoraUsers[widget.pinnedUserId]!),
            ),
            SizedBox(
              width: widget.isShareScreen || widget.pinnedUserId != null
                  ? 0
                  : widget.boxConstraints.maxWidth,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  final agoraUser =
                      widget.agoraUsers[_agoraUserIds.elementAt(index)]!;
                  final user = widget.users[agoraUser.id];
                  return CameraView(
                    key: Key('${agoraUser.id}'),
                    rtcEngine: widget.rtcEngine,
                    channelName: widget.channelName,
                    user: user,
                    agoraUser: agoraUser,
                    isLocal: false,
                    isUserSharesScreen: false,
                    backgroundColor: Colors.grey,
                    isPinned: widget.pinnedUserId == agoraUser.id,
                    onPinIconTap: () => widget.onPin.call(agoraUser),
                  );
                },
                itemCount: _agoraUserIds.length,
              ),
            ),
          ],
        ),
        ValueListenableBuilder<(double, double)>(
          valueListenable: _ownCameraPosition,
          builder: (context, position, child) {
            return Positioned(
              left: position.$1,
              top: position.$2,
              child: child!,
            );
          },
          child: GestureDetector(
            onPanUpdate: (details) =>
                _onPanUpdate(details, widget.boxConstraints),
            child: CameraView(
              rtcEngine: widget.rtcEngine,
              channelName: widget.channelName,
              user: widget.ownUser,
              agoraUser: widget.agoraOwnUser,
              isLocal: true,
              isUserSharesScreen: widget.isShareScreen,
              backgroundColor: Colors.grey,
              isPinned: false,
              onPinIconTap: () => widget.onPin.call(widget.agoraOwnUser),
            ),
          ),
        )
      ],
    );
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    double left = min(
      constraints.maxWidth - _cameraWidth,
      max(
        0.0,
        details.delta.dx + _ownCameraPosition.value.$1,
      ),
    );
    double top = min(
      constraints.maxHeight - _cameraHeight,
      max(
        0.0,
        details.delta.dy + _ownCameraPosition.value.$2,
      ),
    );
    _ownCameraPosition.value = (left, top);
  }
}
