import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/utils/app_utils.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    this.isCurrentUser = false,
  });

  final User user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundImage: NetworkImage(user.avatar),
            child: Center(
              child: Text(
                AppUtils.getDisplayUserName(user, onlyFirstChar: true),
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Text(
              user.displayName,
              style: const TextStyle(
                color: Color.fromARGB(255, 95, 93, 93),
                fontSize: 13,
              ),
            ),
          ),
          if (isCurrentUser) const Text('(You)'),
        ],
      ),
    );
  }
}
