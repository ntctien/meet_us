import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/screens/preview_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class JoinExistRoomScreen extends StatefulWidget {
  const JoinExistRoomScreen({super.key});

  static const String routeName = 'joinExistRoom';

  @override
  State<JoinExistRoomScreen> createState() => _JoinExistRoomScreenState();
}

class _JoinExistRoomScreenState extends State<JoinExistRoomScreen> {
  final _roomIdController = TextEditingController();
  final _isEnable = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _roomIdController.addListener(_roomIdControllerListener);
  }

  @override
  void dispose() {
    _roomIdController.removeListener(_roomIdControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join by code'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _isEnable,
            builder: (ctx, isEnable, child) => TextButton(
              onPressed: isEnable ? _onJoin : null,
              child: const Text('Join Room'),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => AppUtils.dismissFocusNode(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter a code which you were provided',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Gap(16.0),
              TextField(
                controller: _roomIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Example: abc-mnop-xyz',
                ),
                onSubmitted: (_) => _onJoin(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _roomIdControllerListener() {
    _isEnable.value = _roomIdController.text.isNotEmpty;
  }

  void _onJoin() {
    final userState = context.read<UsersState>();
    DialogUtils.showLoading(context);
    userState.getAgoraRoomInfo(roomId: _roomIdController.text).then((value) {
      DialogUtils.dismissLoading();
      context.pushReplacement(PreviewScreen.routeName, extra: value);
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
}
