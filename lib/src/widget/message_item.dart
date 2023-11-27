import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/entity/message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(
                message.representedColorCode == null
                    ? 0xffffffff
                    : int.parse(
                        message.representedColorCode!.replaceAll('#', 'ff'),
                        radix: 16,
                      ),
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
