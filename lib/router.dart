import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/screens/calendar_screen.dart';
import 'package:meet_us/src/screens/change_password_screen.dart';
import 'package:meet_us/src/screens/create_account_screen.dart';
import 'package:meet_us/src/screens/create_new_live_room_screen.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/screens/join_exist_room_screen.dart';
import 'package:meet_us/src/screens/login_screen.dart';
import 'package:meet_us/src/screens/preview_screen.dart';
import 'package:meet_us/src/screens/splash_screen.dart';
import 'package:meet_us/src/screens/streaming_screen.dart';
import 'package:meet_us/src/screens/user_profile_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SplashScreen.routeName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
      redirect: _authRedirect,
      routes: [
        GoRoute(
          path: JoinExistRoomScreen.routeName,
          builder: (context, state) => const JoinExistRoomScreen(),
        ),
        GoRoute(
          path: UserProfileScreen.routeName,
          builder: (context, state) => const UserProfileScreen(),
          routes: [
            GoRoute(
              path: ChangePasswordScreen.routeName,
              builder: (context, state) => const ChangePasswordScreen(),
            ),
          ],
        ),
        GoRoute(
          path: CalendarScreen.routeName,
          builder: (context, state) => const CalendarScreen(),
          routes: [
            GoRoute(
              path: CreateNewLiveRoomScreen.routeName,
              builder: (context, state) => const CreateNewLiveRoomScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: CreateAccountScreen.routeName,
          builder: (context, state) => const CreateAccountScreen(),
        ),
      ],
    ),
    GoRoute(
      path: PreviewScreen.routeName,
      builder: (context, state) {
        final map = state.extra! as Map<String, dynamic>;
        final roomInfo = map['roomInfo']! as AgoraRoomInfo;
        final isNeedRequestToJoin =
            (map['isNeedRequestToJoin'] as bool?) ?? false;
        return PreviewScreen(
          roomInfo: roomInfo,
          isNeedRequestToJoin: isNeedRequestToJoin,
        );
      },
      redirect: _previewScreenRedirect,
    ),
    GoRoute(
      path: StreamingScreen.routeName,
      builder: (context, state) {
        final roomInfo = state.extra! as AgoraRoomInfo;
        return StreamingScreen(roomInfo: roomInfo);
      },
      redirect: _streamingScreenRedirect,
    ),
  ],
);

FutureOr<String>? _authRedirect(BuildContext context, GoRouterState state) {
  final user = context.read<UsersState>().user;
  if (user == null) {
    return LoginScreen.routeName;
  }
  return null;
}

FutureOr<String>? _previewScreenRedirect(
  BuildContext context,
  GoRouterState state,
) {
  final user = context.read<UsersState>().user;
  final map = state.extra! as Map<String, dynamic>;
  final roomInfo = map['roomInfo'] as AgoraRoomInfo?;
  if (user == null || roomInfo == null) {
    return HomeScreen.routeName;
  }

  return null;
}

FutureOr<String>? _streamingScreenRedirect(
  BuildContext context,
  GoRouterState state,
) {
  final user = context.read<UsersState>().user;
  final roomInfo = state.extra as AgoraRoomInfo?;
  if (user == null || roomInfo == null) {
    return HomeScreen.routeName;
  }

  return null;
}
