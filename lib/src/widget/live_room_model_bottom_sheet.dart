import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_us/src/entity/schedule_room.dart';
import 'package:meet_us/src/screens/preview_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class LiveRoomModelBottomSheet extends StatelessWidget {
  const LiveRoomModelBottomSheet({super.key, required this.room});

  final ScheduleRoom room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        )),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Colors.grey,
                ),
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                width: MediaQuery.sizeOf(context).width / 3,
                height: 4.0,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    room.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Gap(16.0),
                FilledButton(
                  onPressed: () => _onJoinRoom(context),
                  child: const Text('Join'),
                ),
              ],
            ),
            const Gap(16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: TextEditingController(
                      text: room.roomId,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Room Code',
                    ),
                  ),
                ),
                const Gap(16.0),
                IconButton(
                  onPressed: () => _copyRoomIdToClipboard(context),
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            const Gap(16.0),
            TextField(
              readOnly: true,
              enableInteractiveSelection: false,
              controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy', 'vi_VN').format(room.startTime),
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                labelText: 'Date',
              ),
            ),
            const Gap(16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: TextEditingController(
                      text: DateFormat('HH:mm', 'vi_VN').format(room.startTime),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Start time',
                    ),
                  ),
                ),
                const Gap(16.0),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: TextEditingController(
                      text: DateFormat('HH:mm', 'vi_VN').format(room.endTime),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'End time',
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16.0),
            Text(
              'Participants',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(16.0),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final user = room.users[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: user.avatar,
                      fit: BoxFit.cover,
                      height: 24,
                      width: 24,
                      errorWidget: (ctx, url, error) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              AppUtils.getDisplayUserName(
                                user,
                                onlyFirstChar: true,
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                    title: Text(user.displayName),
                  );
                },
                itemCount: room.users.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onJoinRoom(BuildContext context) {
    final userState = context.read<UsersState>();
    DialogUtils.showLoading(context);
    userState.getAgoraRoomInfo(roomId: room.roomId).then((value) {
      DialogUtils.dismissLoading();
      context.push(
        PreviewScreen.routeName,
        extra: <String, dynamic>{
          'roomInfo': value,
          'isNeedRequestToJoin': room.hostId != userState.user?.id
        },
      );
    }).onError(
      (e, _) {
        DialogUtils.dismissLoading();
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
      },
    );
  }

  void _copyRoomIdToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: room.roomId));
  }
}
