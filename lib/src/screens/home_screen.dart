import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/screens/preview_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final ownUser = context.select<UsersState, User>((state) => state.user!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Center(child: Text(AppUtils.getDisplayUserName(ownUser))),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                alignment: Alignment.centerLeft,
                textStyle: Theme.of(context).textTheme.titleMedium,
                padding: const EdgeInsets.all(16.0),
              ),
              onPressed: () => _createNewRoom(context),
              child: const Text('New Meeting'),
            ),
            const Gap(16.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                textStyle: Theme.of(context).textTheme.titleMedium,
                padding: const EdgeInsets.all(16.0),
              ),
              onPressed: _joinExistRoom,
              child: const Text('Join With Room ID'),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewRoom(BuildContext context) {
    final userState = context.read<UsersState>();
    DialogUtils.showLoading(context);
    userState.getAgoraRoomInfo().then((value) {
      context.pop();
      context.push(PreviewScreen.routeName, extra: value);
    }).onError((e, __) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    });
  }

  void _joinExistRoom() {}
}
