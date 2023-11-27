import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/core/enum.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/widget/camera_grid_view.dart';
import 'package:meet_us/src/widget/message_model_bottom_sheet.dart';
import 'package:meet_us/src/widget/participants_model_bottom_sheet.dart';
import 'package:provider/provider.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key, required this.roomInfo});

  final AgoraRoomInfo roomInfo;

  static const routeName = '/streamingScreen';

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StreamingState>().joinRoom();
    });
  }

  Color _wrapperColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UsersState>();
    final streamingState = context.watch<StreamingState>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(MediaQuery.paddingOf(context).top),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (ctx, cts) => CameraGridView(
                      rtcEngine: streamingState.agoraEngine!,
                      channelName: widget.roomInfo.channelName,
                      ownUser: userState.user,
                      users: userState.users,
                      agoraOwnUser: streamingState.ownUser,
                      agoraUsers: streamingState.users,
                      boxConstraints: cts,
                    ),
                  ),
                  if (streamingState.connectionStatus !=
                      RoomConnectionStatus.connected)
                    Positioned.fill(
                      child: _buildPlaceHolder(
                        context,
                        streamingState.connectionStatus,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            color: _wrapperColor(context),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white38),
                  icon: Icon(
                    streamingState.isMicroOn ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                  ),
                  onPressed: streamingState.isMicroOn
                      ? streamingState.onCloseMicrophone
                      : streamingState.onOpenMicrophone,
                ),
                const Gap(16.0),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white38),
                  icon: Icon(
                    streamingState.isCameraOn
                        ? Icons.videocam
                        : Icons.videocam_off,
                    color: Colors.white,
                  ),
                  onPressed: streamingState.isCameraOn
                      ? streamingState.onCloseCamera
                      : streamingState.onOpenCamera,
                ),
                const Gap(16.0),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white38),
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () => _onParticipantsButtonTap(context),
                ),
                const Gap(16.0),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white38),
                  icon: const Icon(Icons.message, color: Colors.white),
                  onPressed: () => _onMessageButtonTap(context),
                ),
                const Gap(16.0),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 28.0,
                  ),
                  onPressed: () => _endCall(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceHolder(
    BuildContext context,
    RoomConnectionStatus connectionStatus,
  ) {
    return Container(
      color: Colors.transparent,
      child: connectionStatus == RoomConnectionStatus.connecting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Text(
                'Disconnected',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
    );
  }

  void _onMessageButtonTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 3 / 4,
        minHeight: MediaQuery.sizeOf(context).height * 2 / 4,
      ),
      builder: (context) =>
          MessageModelBottomSheet(roomId: widget.roomInfo.channelName),
    );
  }

  void _onParticipantsButtonTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 3 / 4,
        minHeight: MediaQuery.sizeOf(context).height * 2 / 4,
      ),
      builder: (context) => const ParticipantsModelBottomSheet(),
    );
  }

  void _endCall(BuildContext context) {
    final messageState = context.read<MessageState>();
    context.read<StreamingState>().endCall().then((_) {
      messageState.clearMessagesByRoomId(widget.roomInfo.channelName);
      context.pop();
    }).onError((e, __) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    });
  }
}
