import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/widget/message_model_bottom_sheet.dart';
import 'package:meet_us/src/widget/participants_model_bottom_sheet.dart';
import 'package:provider/provider.dart';

class StreamingBottomActionBar extends StatelessWidget {
  const StreamingBottomActionBar({
    super.key,
    required this.streamingState,
    required this.agoraRoomInfo,
  });

  final StreamingState streamingState;
  final AgoraRoomInfo agoraRoomInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
                streamingState.isCameraOn ? Icons.videocam : Icons.videocam_off,
                color: Colors.white,
              ),
              onPressed: streamingState.isCameraOn
                  ? streamingState.onCloseCamera
                  : streamingState.onOpenCamera,
            ),
            const Gap(16.0),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: const BoxDecoration(
                color: Colors.white38,
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<_ActionItem?>(
                initialValue: null,
                tooltip: 'Options',
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (item) => _onOptionMenuSelected(context, item),
                itemBuilder: _buildPopupMenuEntry,
              ),
            ),
            const Gap(20.0),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              icon: const Icon(Icons.call_end, color: Colors.white),
              onPressed: () => _endCall(context),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<_ActionItem>> _buildPopupMenuEntry(BuildContext context) {
    final iconColor = Theme.of(context).primaryColor;
    return <PopupMenuEntry<_ActionItem>>[
      PopupMenuItem<_ActionItem>(
        value: _ActionItem.shareScreen,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              streamingState.isShareScreen
                  ? Icons.stop_screen_share
                  : Icons.screen_share,
              color: iconColor,
            ),
            const Gap(8.0),
            Text(
              streamingState.isShareScreen
                  ? _ActionItem.shareScreen.alternativeName
                  : _ActionItem.shareScreen.name,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
      PopupMenuItem<_ActionItem>(
        value: _ActionItem.participants,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, color: iconColor),
            const Gap(8.0),
            Text(
              _ActionItem.participants.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      PopupMenuItem<_ActionItem>(
        value: _ActionItem.chat,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.message, color: iconColor),
            const Gap(8.0),
            Text(
              _ActionItem.chat.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ];
  }

  void _onOptionMenuSelected(BuildContext context, _ActionItem? item) {
    if (item == null) {
      return;
    }
    switch (item) {
      case _ActionItem.shareScreen:
        if (streamingState.isShareScreen) {
          streamingState.onStopScreenCapture().onError((e, _) {
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
          });
          return;
        }
        streamingState.onStartScreenCapture().onError((e, _) {
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
        });
        return;
      case _ActionItem.participants:
        _onParticipantsButtonTap(context);
        return;
      case _ActionItem.chat:
        _onMessageButtonTap(context);
        return;
    }
  }

  void _onMessageButtonTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 3 / 4,
      ),
      builder: (context) =>
          MessageModelBottomSheet(roomId: agoraRoomInfo.channelName),
    );
  }

  void _onParticipantsButtonTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 3 / 4,
      ),
      builder: (context) => const ParticipantsModelBottomSheet(),
    );
  }

  void _endCall(BuildContext context) {
    final messageState = context.read<MessageState>();
    streamingState.endCall().then((_) {
      messageState.clearMessagesByRoomId(agoraRoomInfo.channelName);
      context.pop();
    }).onError((e, __) {
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
    });
  }
}

enum _ActionItem {
  shareScreen('Share Screen', 'Stop Share Screen'),
  participants('Participants', ''),
  chat('Chat', '');

  const _ActionItem(this.name, this.alternativeName);

  final String name;
  final String alternativeName;
}

enum RestfulResponseErrorCode {
  expiredToken('FIREBASE_TOKEN_EXPIRED_TIME');

  const RestfulResponseErrorCode(this.code);

  final String code;
}
