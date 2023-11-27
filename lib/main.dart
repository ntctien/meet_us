import 'package:flutter/material.dart';
import 'package:meet_us/router.dart';
import 'package:meet_us/src/core/const.dart';
import 'package:meet_us/src/service/socket_service.dart';
import 'package:meet_us/src/service/user_service.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<UserService>(create: (_) => UserService(domain)),
        Provider<SocketService>(create: (_) => SocketService(domain)),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersState>(
            create: (context) => UsersState(context.read<UserService>()),
          ),
          ChangeNotifierProvider<StreamingState>(
            create: (context) => StreamingState(),
          ),
          ChangeNotifierProvider<MessageState>(
            create: (context) => MessageState(context.read<SocketService>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Meet Us',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(primary: Color(0xff0B82E6)),
          ),
          // theme: ThemeData(primarySwatch: Color(0xff0B82E6)),
          routerConfig: router,
        ),
      ),
    ),
  );
}
