import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/screens/create_account_screen.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/screens/login_screen.dart';
import 'package:meet_us/src/screens/preview_screen.dart';
import 'package:meet_us/src/screens/streaming_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
      redirect: _authRedirect,
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
        final roomInfo = state.extra! as AgoraRoomInfo;
        return PreviewScreen(roomInfo: roomInfo);
      },
      redirect: _streamingScreenRedirect,
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
