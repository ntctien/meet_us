import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/core/enum.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/widget/camera_grid_view.dart';
import 'package:meet_us/src/widget/streaming_bottom_action_bar.dart';
import 'package:provider/provider.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key, required this.roomInfo});

  final AgoraRoomInfo roomInfo;

  static const routeName = '/streaming';

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StreamingState>().joinRoom();
      context.read<MessageState>().joinRoom(widget.roomInfo.channelName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UsersState>();
    final streamingState = context.watch<StreamingState>();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(MediaQuery.paddingOf(context).top),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (ctx, cts) => CameraGridView(
                        rtcEngine: streamingState.agoraEngine!,
                        channelName: widget.roomInfo.channelName,
                        isShareScreen: streamingState.isShareScreen,
                        ownUser: userState.user,
                        users: userState.users,
                        pinnedUserId: streamingState.pinnedUserId,
                        agoraOwnUser: streamingState.ownUser,
                        agoraUsers: streamingState.users,
                        boxConstraints: cts,
                        onPin: streamingState.pinUser,
                        onUnpin: streamingState.unPinUser,
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
            StreamingBottomActionBar(
              streamingState: streamingState,
              agoraRoomInfo: widget.roomInfo,
            ),
          ],
        ),
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
}
