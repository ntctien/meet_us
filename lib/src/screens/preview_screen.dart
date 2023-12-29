import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/agora_user.dart';
import 'package:meet_us/src/screens/streaming_screen.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.roomInfo});

  final AgoraRoomInfo roomInfo;

  static const routeName = '/preview';

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _navigateBack = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_addPostFrameCallback);
  }

  @override
  void deactivate() {
    super.deactivate();
    final streamingState = context.read<StreamingState>();
    if (_navigateBack) {
      streamingState.endPreview();
    }
  }

  void _addPostFrameCallback(Duration timeStamp) async {
    final user = context.read<UsersState>().user!;
    await context.read<StreamingState>().setupVideoSDKEngine(
          widget.roomInfo,
          AgoraUser(
            id: user.id,
            isCameraOn: false,
            isMicroOn: false,
          ),
        );
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
          FilledButton(
            style: FilledButton.styleFrom(
              textStyle: Theme.of(context).textTheme.titleMedium,
              padding:
                  const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
            ),
            onPressed: () => _onJoin(streamingState),
            child: const Text('Join Room'),
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
}
