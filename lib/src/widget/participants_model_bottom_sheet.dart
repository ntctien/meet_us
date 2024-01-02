import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/widget/string_extensions.dart';
import 'package:meet_us/src/widget/user_item.dart';
import 'package:provider/provider.dart';

class ParticipantsModelBottomSheet extends StatelessWidget {
  const ParticipantsModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UsersState>();
    final streamingState = context.watch<StreamingState>();
    final users = _getUsers(streamingState.users.keys, userState.users);
    final requestedUsers = streamingState.requestJoinRoomUsers.values;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: Colors.grey,
          ),
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          width: MediaQuery.sizeOf(context).width / 3,
          height: 4.0,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Joined users',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: users.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return UserItem(
                  user: context.read<UsersState>().user!,
                  isCurrentUser: true,
                );
              }
              return UserItem(user: users.elementAt(index - 1));
            },
          ),
        ),
        if (streamingState.requestJoinRoomUsers.isNotEmpty) ...[
          const Gap(16.0),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Request to join users',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: requestedUsers.length,
              itemBuilder: (context, index) {
                final user = requestedUsers.elementAt(index);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundImage: NetworkImage(user.avatar),
                        child: Center(
                          child: Text(user.name.isEmpty ? '' : user.name[0]),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Text(
                          user.name.useCorrectEllipsis(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 95, 93, 93),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _onAccept(streamingState, user.userId),
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            _onDecline(streamingState, user.userId),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  List<User> _getUsers(Iterable<int> agoraUserIds, Map<int, User> usersMap) {
    final users = <User>[];
    for (final id in agoraUserIds) {
      if (usersMap.containsKey(id)) {
        users.add(usersMap[id]!);
      }
    }
    return users;
  }

  void _onAccept(StreamingState state, int userId) {
    state.replyJoinRequest(state.agoraRoomInfo!.channelName, userId, true);
  }

  void _onDecline(StreamingState state, int userId) {
    state.replyJoinRequest(state.agoraRoomInfo!.channelName, userId, false);
  }
}
