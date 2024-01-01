import 'dart:collection';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:meet_us/src/core/enum.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/service/socket_service.dart';

class StreamingState extends ChangeNotifier {
  final SocketService _socketService;

  StreamingState(this._socketService) {
    _socketService.onReceiveRequestJoinRoom = _onReceiveRequestJoinRoom;
  }

  ChannelMediaOptions get _shareScreenChannelMediaOptions =>
      const ChannelMediaOptions(
        publishCameraTrack: false,
        publishMicrophoneTrack: true,
        publishScreenTrack: true,
        publishScreenCaptureAudio: false,
        publishScreenCaptureVideo: true,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      );

  ChannelMediaOptions get _videoCallChannelMediaOptions =>
      const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        publishScreenTrack: false,
        publishScreenCaptureAudio: false,
        publishScreenCaptureVideo: false,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      );

  RoomConnectionStatus _connectionStatus = RoomConnectionStatus.disconnected;
  RoomConnectionStatus get connectionStatus => _connectionStatus;

  AgoraUser _ownUser =
      const AgoraUser(id: 0, isCameraOn: false, isMicroOn: false);
  AgoraUser get ownUser => _ownUser;
  bool get isMicroOn => _ownUser.isMicroOn;
  bool get isCameraOn => _ownUser.isCameraOn;
  bool _isShareScreen = false;
  bool get isShareScreen => _isShareScreen;
  int? _pinnedUserId;
  int? get pinnedUserId => _pinnedUserId;

  // RTC engine
  RtcEngine? _agoraEngine;
  RtcEngine? get agoraEngine => _agoraEngine;

  AgoraRoomInfo? _agoraRoomInfo;
  AgoraRoomInfo? get agoraRoomInfo => _agoraRoomInfo;

  RtcEngineEventHandler? _eventHandler;

  Map<int, AgoraUser> _users = <int, AgoraUser>{};
  UnmodifiableMapView<int, AgoraUser> get users =>
      UnmodifiableMapView<int, AgoraUser>(_users);

  // Map<int, RequestJoinRoomUser> _requestJoinRoomUsers =
  //     <int, RequestJoinRoomUser>{};
  // UnmodifiableMapView<int, RequestJoinRoomUser> get requestJoinRoomUsers =>
  //     UnmodifiableMapView<int, RequestJoinRoomUser>(_requestJoinRoomUsers);

  Function onUserJoined = (int id) {};

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
      onLocalVideoStateChanged: _onLocalVideoStateChanged,
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
    final newUsers = Map<int, AgoraUser>.from(_users);
    newUsers[remoteUid] =
        AgoraUser(id: remoteUid, isCameraOn: false, isMicroOn: false);
    _users = newUsers;
    notifyListeners();
  }

  void _onUserOffline(
    RtcConnection connection,
    int remoteUid,
    UserOfflineReasonType reason,
  ) {
    final newUsers = Map<int, AgoraUser>.from(_users);
    newUsers.remove(remoteUid);
    _users = newUsers;
    notifyListeners();
  }

  void _onLocalVideoStateChanged(
    VideoSourceType sourceType,
    LocalVideoStreamState state,
    LocalVideoStreamError err,
  ) {
    if (sourceType.value() == VideoSourceType.videoSourceScreen.value()) {
      switch (state) {
        case LocalVideoStreamState.localVideoStreamStateCapturing:
          break;
        case LocalVideoStreamState.localVideoStreamStateEncoding:
          _isShareScreen = true;
          notifyListeners();
          break;
        case LocalVideoStreamState.localVideoStreamStateStopped:
          _isShareScreen = false;
          notifyListeners();
          break;
        case LocalVideoStreamState.localVideoStreamStateFailed:
          _agoraEngine!.stopScreenCapture();
          break;
      }
    }
  }

  void _onRemoteVideoStateChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteVideoState state,
    RemoteVideoStateReason reason,
    int elapsed,
  ) {
    final isCameraOn = ![
      RemoteVideoState.remoteVideoStateStopped,
      RemoteVideoState.remoteVideoStateFailed,
    ].contains(state);
    final agoraUser = AgoraUser(
      id: remoteUid,
      isCameraOn: isCameraOn,
      isMicroOn: _users[remoteUid]?.isMicroOn ?? false,
    );
    if (agoraUser != _users[remoteUid]) {
      final newUsers = Map<int, AgoraUser>.from(_users);
      newUsers[remoteUid] = agoraUser;
      _users = newUsers;
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
    final isMicroOn = ![
      RemoteAudioState.remoteAudioStateStopped,
      RemoteAudioState.remoteAudioStateFailed,
    ].contains(state);
    final agoraUser = AgoraUser(
      id: remoteUid,
      isCameraOn: _users[remoteUid]?.isCameraOn ?? false,
      isMicroOn: isMicroOn,
    );
    if (agoraUser != _users[remoteUid]) {
      final newUsers = Map<int, AgoraUser>.from(_users);
      newUsers[remoteUid] = agoraUser;
      _users = newUsers;
      notifyListeners();
    }
  }

  void _onReceiveRequestJoinRoom(dynamic value) {
    // final userId = value['uid']! as int;
    // final statusString = (value['status'] as String?) ?? '';
    // RequestJoinRoomStatus status = RequestJoinRoomStatus.unknown;
    // switch (statusString) {
    //   case 'APPROVED':
    //     status = RequestJoinRoomStatus.approved;
    //     break;
    //   case 'WAITING':
    //     status = RequestJoinRoomStatus.waiting;
    //     break;
    //   case 'DECLINE':
    //     status = RequestJoinRoomStatus.decline;
    //     break;
    // }
    // final requestUser = RequestJoinRoomUser(
    //   id: userId,
    //   requestJoinRoomStatus: status,
    // );
    // final mapUser = Map<int, RequestJoinRoomUser>.from(_requestJoinRoomUsers);
    // mapUser[requestUser.id] = requestUser;
    // _requestJoinRoomUsers = mapUser;
    // notifyListeners();
  }

  Future<void> joinRoom() async {
    _connectionStatus = RoomConnectionStatus.connecting;
    notifyListeners();
    const options = ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      publishCameraTrack: true,
      publishMicrophoneTrack: true,
      publishScreenTrack: false,
      publishScreenCaptureAudio: false,
      publishScreenCaptureVideo: false,
      autoSubscribeVideo: true,
      autoSubscribeAudio: true,
    );
    await _agoraEngine!.joinChannel(
      token: _agoraRoomInfo!.token,
      channelId: _agoraRoomInfo!.channelName,
      options: options,
      uid: _ownUser.id,
    );
  }

  Future<void> endCall() async {
    if (isCameraOn) {
      await onCloseCamera();
    }
    if (isMicroOn) {
      await onCloseMicrophone();
    }
    if (_isShareScreen) {
      await onStopScreenCapture();
    }
    await _agoraEngine?.leaveChannel();
    await _agoraEngine?.release();
    _ownUser = const AgoraUser(id: 0, isCameraOn: false, isMicroOn: false);
    _users.clear();
    _connectionStatus = RoomConnectionStatus.disconnected;
    _agoraRoomInfo = null;
    _ownUser = _ownUser.copyWith(isCameraOn: false, isMicroOn: false);
    _pinnedUserId = null;
    onUserJoined = (int id) {};
  }

  Future<void> endPreview() async {
    if (_agoraEngine == null) {
      return;
    }
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
    if (_agoraEngine == null || _isShareScreen) {
      return;
    }
    await _agoraEngine!.enableLocalVideo(true);
    await _agoraEngine!
        .updateChannelMediaOptions(_videoCallChannelMediaOptions);
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

  Future<void> onStartScreenCapture() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.startScreenCapture(
      const ScreenCaptureParameters2(
        captureAudio: true,
        audioParams: ScreenAudioParameters(
          sampleRate: 16000,
          channels: 2,
          captureSignalVolume: 100,
        ),
        captureVideo: true,
        videoParams: ScreenVideoParameters(
          dimensions: VideoDimensions(height: 1280, width: 720),
          frameRate: 15,
          bitrate: 600,
        ),
      ),
    );
    await _agoraEngine!
        .updateChannelMediaOptions(_shareScreenChannelMediaOptions);
    await onCloseCamera();
  }

  Future<void> onStopScreenCapture() async {
    if (_agoraEngine == null) {
      return;
    }
    await _agoraEngine!.stopScreenCapture();
  }

  void pinUser(AgoraUser user) {
    _pinnedUserId = user.id;
    notifyListeners();
  }

  void unPinUser(AgoraUser user) {
    _pinnedUserId = null;
    notifyListeners();
  }
}
