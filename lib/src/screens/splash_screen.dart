import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/screens/login_screen.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final userState = context.read<UsersState>();
    final messageState = context.read<MessageState>();
    final token = userState.getAccessToken();
    if (token == null || token.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        context.go(LoginScreen.routeName);
      });
    } else {
      userState.initAuthenticationStateFirstOpenApp(token).then((_) {
        messageState.initializeSocket(
          userState.user!.token,
          userState.user!.displayName,
        );
        context.go(HomeScreen.routeName);
      }).onError((e, _) {
        userState.resetAuthenticationState().then((_) {
          context.go(LoginScreen.routeName);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'app_icon',
          child: Image.asset(
            'assets/images/app_icon.png',
            width: 150.0,
            height: 150.0,
          ),
        ),
      ),
    );
  }
}
