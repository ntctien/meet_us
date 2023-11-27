import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/entity/agora_user.dart';
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
    final users = _getUsers(streamingState.users, userState.users);
    return Column(
      children: [
        const Gap(8.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: Colors.grey,
          ),
          clipBehavior: Clip.hardEdge,
          width: MediaQuery.sizeOf(context).width / 3,
          height: 4.0,
        ),
        const Gap(8.0),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: streamingState.users.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return UserItem(
                  user: context.read<UsersState>().user!,
                  isCurrentUser: true,
                );
              }
              return UserItem(user: users.elementAt(index + 1));
            },
          ),
        ),
      ],
    );
  }

  List<User> _getUsers(List<AgoraUser> agoraUsers, Map<int, User> usersMap) {
    final users = <User>[];
    for (final user in agoraUsers) {
      if (usersMap[user.id] != null) {
        users.add(usersMap[user.id]!);
      }
    }
    return users;
  }
}
