import 'dart:collection';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:meet_us/src/core/enum.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/agora_user.dart';

class StreamingState extends ChangeNotifier {
  RoomConnectionStatus _connectionStatus = RoomConnectionStatus.disconnected;
  RoomConnectionStatus get connectionStatus => _connectionStatus;
  bool get isMicroOn => _ownUser.isMicroOn;
  bool get isCameraOn => _ownUser.isCameraOn;

  AgoraUser _ownUser =
      const AgoraUser(id: 0, isCameraOn: false, isMicroOn: false);
  AgoraUser get ownUser => _ownUser;
  int? _mostActiveUserUid;
  int? get mostActiveUserUid => _mostActiveUserUid;

  // RTC engine
  RtcEngine? _agoraEngine;
  RtcEngine? get agoraEngine => _agoraEngine;

  AgoraRoomInfo? _agoraRoomInfo;
  AgoraRoomInfo? get agoraRoomInfo => _agoraRoomInfo;

  RtcEngineEventHandler? _eventHandler;

  final _users = <AgoraUser>[];
  UnmodifiableListView<AgoraUser> get users =>
      UnmodifiableListView<AgoraUser>(_users);

  Future<void> setupVideoSDKEngine(
    AgoraRoomInfo roomInfo,
    AgoraUser user,
  ) async {
    _ownUser = user;
    _agoraRoomInfo = roomInfo;
    //create an instance of the Agora engine
    _agoraEngine = createAgoraRtcEngine();
    notifyListeners();
    await _agoraEngine!.enableVideo();
    await _agoraEngine!.enableAudio();

    await _agoraEngine!.initialize(RtcEngineContext(
      appId: _agoraRoomInfo!.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // Register the event handler
    if (_eventHandler != null) {
      _agoraEngine!.unregisterEventHandler(_eventHandler!);
    }
    _eventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: _onJoinChannelSuccess,
      onLeaveChannel: _onLeaveChannel,
      onRejoinChannelSuccess: _onRejoinChannelSuccess,
      onUserJoined: _onUserJoined,
      onUserOffline: _onUserOffline,
      onActiveSpeaker: _onActiveSpeaker,
      onRemoteVideoStateChanged: _onRemoteVideoStateChanged,
      onRemoteAudioStateChanged: _onRemoteAudioStateChanged,
    );
    _agoraEngine!.registerEventHandler(_eventHandler!);
  }

  void _onJoinChannelSuccess(RtcConnection connection, int elapsed) {
    _connectionStatus = RoomConnectionStatus.connected;
    notifyListeners();
  }

  void _onLeaveChannel(RtcConnection connection, RtcStats stats) {
    _connectionStatus = RoomConnectionStatus.disconnected;
    notifyListeners();
  }

  void _onRejoinChannelSuccess(RtcConnection connection, int elapsed) {
    _connectionStatus = RoomConnectionStatus.connected;
    notifyListeners();
  }

  void _onUserJoined(RtcConnection connection, int remoteUid, int elapsed) {
    _users.add(
      AgoraUser(id: remoteUid, isCameraOn: false, isMicroOn: false),
    );
    notifyListeners();
  }

  void _onUserOffline(
    RtcConnection connection,
    int remoteUid,
    UserOfflineReasonType reason,
  ) {
    _users.removeWhere((element) => element.id == remoteUid);
    notifyListeners();
  }

  void _onActiveSpeaker(RtcConnection connection, int remoteUid) {
    _mostActiveUserUid = remoteUid;
    notifyListeners();
  }

  void _onRemoteVideoStateChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteVideoState state,
    RemoteVideoStateReason reason,
    int elapsed,
  ) {
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].id != remoteUid) {
        continue;
      }
      final user = _users[i].copyWith(
        isCameraOn: ![
          RemoteVideoState.remoteVideoStateStopped,
          RemoteVideoState.remoteVideoStateFailed
        ].contains(state),
      );
      _users[i] = user;
      notifyListeners();
    }
  }

  void _onRemoteAudioStateChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteAudioState state,
    RemoteAudioStateReason reason,
    int elapsed,
  ) {
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].id != remoteUid) {
        continue;
      }
      final user = _users[i].copyWith(
        isMicroOn: ![
          RemoteAudioState.remoteAudioStateStopped,
          RemoteAudioState.remoteAudioStateFailed,
        ].contains(state),
      );
      _users[i] = user;
      notifyListeners();
    }
  }

  Future<void> joinRoom() async {
    _connectionStatus = RoomConnectionStatus.connecting;
    notifyListeners();
    const options = ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await _agoraEngine!.joinChannel(
      token: _agoraRoomInfo!.token,
      channelId: _agoraRoomInfo!.channelName,
      options: options,
      uid: _ownUser.id,
    );
    await _agoraEngine!.enableLocalAudio(false);
  }

  Future<void> endCall() async {
    await _agoraEngine?.leaveChannel();
    await _agoraEngine?.release();
    _ownUser = const AgoraUser(id: 0, isCameraOn: false, isMicroOn: false);
    _users.clear();
    _connectionStatus = RoomConnectionStatus.disconnected;
    _agoraRoomInfo = null;
    _ownUser = _ownUser.copyWith(isCameraOn: false, isMicroOn: false);
    _mostActiveUserUid = null;
  }

  Future<void> endPreview() async {
    if (isCameraOn) {
      onClosePreviewCamera();
    }
    if (isMicroOn) {
      onCloseMicrophone();
    }
    if (_eventHandler != null) {
      _agoraEngine!.unregisterEventHandler(_eventHandler!);
    }
    await _agoraEngine?.release();
  }

  Future<void> onOpenPreviewCamera() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.startPreview();
    _ownUser = _ownUser.copyWith(isCameraOn: true);
    notifyListeners();
  }

  Future<void> onClosePreviewCamera() async {
    if (_agoraEngine == null) {
      return;
    }
    await agoraEngine!.stopPreview();
    _ownUser = _ownUser.copyWith(isCameraOn: false);
    notifyListeners();
  }

  Future<void> onOpenCamera() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.enableLocalVideo(true);
    _ownUser = _ownUser.copyWith(isCameraOn: true);
    notifyListeners();
  }

  Future<void> onCloseCamera() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.enableLocalVideo(false);
    _ownUser = _ownUser.copyWith(isCameraOn: false);
    notifyListeners();
  }

  Future<void> onOpenMicrophone() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.enableLocalAudio(true);
    _ownUser = _ownUser.copyWith(isMicroOn: true);
    notifyListeners();
  }

  Future<void> onCloseMicrophone() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.enableLocalAudio(false);
    _ownUser = _ownUser.copyWith(isMicroOn: false);
    notifyListeners();
  }
}
