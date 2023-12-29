import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/widget/user_item.dart';
import 'package:provider/provider.dart';

class ParticipantsModelBottomSheet extends StatelessWidget {
  const ParticipantsModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UsersState>();
    final streamingState = context.watch<StreamingState>();
    final users = _getUsers(streamingState.users.keys, userState.users);
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
        // if (streamingState.requestJoinRoomUsers.isNotEmpty) ...[
        //   const Gap(16.0),
        //   Expanded(
        //     flex: 1,
        //     child: ListView.builder(
        //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //       itemCount: streamingState.requestJoinRoomUsers.length + 1,
        //       itemBuilder: (context, index) {
        //         final user = streamingState.requestJoinRoomUsers[index];
        //         return Container(
        //           margin: const EdgeInsets.symmetric(vertical: 10),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: Text(
        //                   user.email,
        //                   style: const TextStyle(
        //                     color: Color.fromARGB(255, 95, 93, 93),
        //                     fontSize: 13,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ],
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
}
