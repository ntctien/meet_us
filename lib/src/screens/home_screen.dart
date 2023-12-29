import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/screens/calendar_screen.dart';
import 'package:meet_us/src/screens/join_exist_room_screen.dart';
import 'package:meet_us/src/screens/preview_screen.dart';
import 'package:meet_us/src/screens/user_profile_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final ownUser = context.select<UsersState, User>((state) => state.user!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
              onPressed: () => _navigateToCalendarScreen(context),
              icon: const Icon(Icons.calendar_month, color: Colors.blue)),
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateToUserProfileScreen(context),
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundImage: NetworkImage(ownUser.avatar),
              child: Center(
                child: Text(
                  AppUtils.getDisplayUserName(ownUser, onlyFirstChar: true),
                ),
              ),
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Padding(
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
                onPressed: () => _joinExistRoom(context),
                child: const Text('Join With Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToUserProfileScreen(BuildContext context) {
    context.push('${HomeScreen.routeName}/${UserProfileScreen.routeName}');
  }

  void _navigateToCalendarScreen(BuildContext context) {
    context.push('${HomeScreen.routeName}/${CalendarScreen.routeName}');
  }

  void _createNewRoom(BuildContext context) {
    final userState = context.read<UsersState>();
    DialogUtils.showLoading(context);
    userState.getAgoraRoomInfo().then((value) {
      DialogUtils.dismissLoading();
      context.push(PreviewScreen.routeName, extra: value);
    }).onError((e, _) {
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
    });
  }

  void _joinExistRoom(BuildContext context) {
    context.push('${HomeScreen.routeName}/${JoinExistRoomScreen.routeName}');
  }
}
