import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/widget/message_item.dart';
import 'package:provider/provider.dart';

class MessageModelBottomSheet extends StatefulWidget {
  const MessageModelBottomSheet({super.key, required this.roomId});

  final String roomId;

  @override
  State<MessageModelBottomSheet> createState() =>
      _MessageModelBottomSheetState();
}

class _MessageModelBottomSheetState extends State<MessageModelBottomSheet> {
  final msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messagesState = context.watch<MessageState>();
    final messages = messagesState.messagesByRoomId(widget.roomId);
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
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageItem(
                message: messages[messages.length - 1 - index],
              );
            },
            reverse: true,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            16.0,
            16.0,
            16.0,
            MediaQuery.viewInsetsOf(context).bottom + 16.0,
          ),
          child: TextField(
            controller: msgController,
            decoration: InputDecoration(
              hintText: 'Send message',
              filled: true,
              fillColor: const Color(0xFFE8E9EB),
              suffixIcon: IconButton(
                onPressed: () => _sendMessage(context),
                icon: const Icon(Icons.send_outlined),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }

  void _sendMessage(BuildContext context) {
    if (msgController.text.isEmpty) {
      return;
    }
    final messageState = context.read<MessageState>();
    messageState.sendMessage(widget.roomId, msgController.text);
    msgController.text = '';
  }
}
