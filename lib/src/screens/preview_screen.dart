import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/core/enum.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/screens/streaming_screen.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({
    super.key,
    required this.roomInfo,
    required this.isNeedRequestToJoin,
  });

  final AgoraRoomInfo roomInfo;
  final bool isNeedRequestToJoin;

  static const routeName = '/preview';

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _navigateBack = true;
  final _loading = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_addPostFrameCallback);
  }

  @override
  void deactivate() {
    super.deactivate();
    final streamingState = context.read<StreamingState>();
    final messageState = context.read<MessageState>();
    if (_navigateBack) {
      streamingState.endPreview();
      messageState.leaveRoom(widget.roomInfo.channelName);
    }
    streamingState.onHostRepliedJoinRequest = null;
  }

  void _addPostFrameCallback(Duration timeStamp) async {
    final user = context.read<UsersState>().user!;
    final streamingState = context.read<StreamingState>();
    final messageState = context.read<MessageState>();
    await streamingState.setupVideoSDKEngine(
      widget.roomInfo,
      AgoraUser(
        id: user.id,
        isCameraOn: false,
        isMicroOn: false,
      ),
    );
    messageState.joinRoom(widget.roomInfo.channelName);
    streamingState.onHostRepliedJoinRequest = _onHostRepliedJoinRequest;
    [Permission.camera, Permission.microphone].request().then((value) {
      final streamingState = context.read<StreamingState>();
      if (value[Permission.camera] != null) {
        if (value[Permission.camera]!.isGranted) {
          _onOpenVideo(streamingState);
        }
      }
      if (value[Permission.microphone] != null) {
        if (value[Permission.microphone]!.isGranted) {
          _onOpenMicrophone(streamingState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamingState = context.watch<StreamingState>();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.maxFinite),
          const Spacer(),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              LayoutBuilder(builder: (ctx, cts) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                  width: cts.maxWidth / 1.5,
                  height: (cts.maxWidth / 1.5) * 4 / 3,
                  child: streamingState.agoraEngine != null
                      ? streamingState.isCameraOn
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: streamingState.agoraEngine!,
                                canvas: const VideoCanvas(uid: 0),
                                useFlutterTexture: true,
                              ),
                              onAgoraVideoViewCreated: (viewId) =>
                                  _onOpenVideo(streamingState),
                            )
                          : null
                      : const Center(child: CircularProgressIndicator()),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IconButton(
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.black26),
                      icon: Icon(
                        streamingState.isMicroOn ? Icons.mic : Icons.mic_off,
                        color: streamingState.isMicroOn
                            ? Colors.white
                            : Colors.red,
                      ),
                      onPressed: streamingState.isMicroOn
                          ? () => _onCloseMicrophone(streamingState)
                          : () => _onOpenMicrophone(streamingState),
                    ),
                  ),
                  const Gap(16.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IconButton(
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.black26),
                      icon: Icon(
                        streamingState.isCameraOn
                            ? Icons.videocam
                            : Icons.videocam_off,
                        color: streamingState.isCameraOn
                            ? Colors.white
                            : Colors.red,
                      ),
                      onPressed: streamingState.isCameraOn
                          ? () => _onCloseVideo(streamingState)
                          : () => _onOpenVideo(streamingState),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          ValueListenableBuilder<bool>(
            valueListenable: _loading,
            builder: (context, loading, child) {
              return FilledButton(
                style: FilledButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64.0,
                    vertical: 16.0,
                  ),
                ),
                onPressed: loading
                    ? null
                    : widget.isNeedRequestToJoin
                        ? () => _onRequestToJoin(streamingState)
                        : () => _onJoin(streamingState),
                child: loading ? const CircularProgressIndicator() : child!,
              );
            },
            child: Text(
              widget.isNeedRequestToJoin ? 'Request Join Room' : 'Join Room',
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> _onOpenVideo(StreamingState state) async {
    try {
      await state.onOpenPreviewCamera();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$e'),
            ),
          ),
        );
      }
    }
  }

  Future<bool> _onCloseVideo(StreamingState state) async {
    try {
      await state.onClosePreviewCamera();
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$e'),
            ),
          ),
        );
      }
      return false;
    }
  }

  Future<void> _onOpenMicrophone(StreamingState state) async {
    try {
      await state.onOpenMicrophone();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$e'),
            ),
          ),
        );
      }
    }
  }

  Future<bool> _onCloseMicrophone(StreamingState state) async {
    try {
      await state.onCloseMicrophone();
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$e'),
            ),
          ),
        );
      }
      return false;
    }
  }

  void _onRequestToJoin(StreamingState state) async {
    _loading.value = true;
    final status = await state.requestToJoinRoom(widget.roomInfo.channelName);
    if (status == RequestJoinRoomStatus.approved) {
      _onJoin(state);
    }
  }

  void _onJoin(StreamingState state) async {
    if (state.isCameraOn) {
      final isSuccess = await _onCloseVideo(state);
      if (!isSuccess) {
        return;
      }
    }
    if (state.isMicroOn) {
      final isSuccess = await _onCloseMicrophone(state);
      if (!isSuccess) {
        return;
      }
    }
    if (mounted) {
      _navigateBack = false;
      context.pushReplacement(
        StreamingScreen.routeName,
        extra: widget.roomInfo,
      );
    }
  }

  void _onHostRepliedJoinRequest(int uid, RequestJoinRoomStatus status) {
    final user = context.read<UsersState>().user!;
    if (user.id == uid) {
      switch (status) {
        case RequestJoinRoomStatus.approved:
          final streamingState = context.read<StreamingState>();
          _onJoin(streamingState);
          break;
        case RequestJoinRoomStatus.decline:
          _loading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Room's host declined your join request"),
              ),
            ),
          );
          break;
        default:
          return;
      }
    }
  }
}
