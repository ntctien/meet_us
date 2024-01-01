import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/entity/message.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/utils/app_utils.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
    this.user,
  });
  final User? user;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Color(message.representedColorCode == null
                ? 0xffffffff
                : int.parse(
                    message.representedColorCode!.replaceAll('#', 'ff'),
                    radix: 16,
                  )),
            foregroundImage: user == null ? null : NetworkImage(user!.avatar),
            child: Center(
              child: Text(
                user == null
                    ? message.name
                    : AppUtils.getDisplayUserName(user, onlyFirstChar: true),
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 95, 93, 93),
                  fontSize: 13,
                ),
              ),
              const Gap(8),
              Text(
                message.content,
                style: const TextStyle(fontSize: 16),
              )
            ],
          )
        ],
      ),
    );
  }
}
