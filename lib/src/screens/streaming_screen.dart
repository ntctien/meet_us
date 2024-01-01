import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final streamingState = context.read<StreamingState>();
    final userState = context.read<UsersState>();
    streamingState.joinRoom();
    streamingState.onUserJoined = (int id) {
      if (userState.users[id] == null) {
        userState.getUserInfoById(id);
      }
    };
    context.read<MessageState>().joinRoom(widget.roomInfo.channelName);
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UsersState>();
    final streamingState = context.watch<StreamingState>();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: const Color(0xff333333),
        appBar: streamingState.users.isEmpty
            ? null
            : AppBar(
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.roomInfo.channelName),
                ),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
                actions: [
                  IconButton(
                    onPressed: () => _copyRoomIdToClipboard(context),
                    icon:
                        const Icon(Icons.copy, color: Colors.white, size: 20.0),
                  ),
                ],
                centerTitle: true,
              ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    Align(
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: streamingState.users.isEmpty &&
                            !streamingState.isShareScreen &&
                            streamingState.pinnedUserId == null &&
                            streamingState.connectionStatus ==
                                RoomConnectionStatus.connected,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'You are the only one in this room',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(16.0),
                              const Text(
                                'Invite people to join you by code:',
                                style: TextStyle(color: Colors.white),
                              ),
                              const Gap(24.0),
                              IgnorePointer(
                                ignoring: true,
                                child: TextField(
                                  canRequestFocus: false,
                                  controller: TextEditingController(
                                    text: widget.roomInfo.channelName,
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    floatingLabelStyle:
                                        const TextStyle(color: Colors.white),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    labelText: 'Room Code',
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          _copyRoomIdToClipboard(context),
                                      icon: const Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  void _copyRoomIdToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.roomInfo.channelName));
  }
}
