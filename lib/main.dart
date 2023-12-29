import 'package:flutter/material.dart';
import 'package:meet_us/router.dart';
import 'package:meet_us/src/core/const.dart';
import 'package:meet_us/src/state/calendar_state.dart';
import 'package:meet_us/src/service/calendar_service.dart';
import 'package:meet_us/src/service/socket_service.dart';
import 'package:meet_us/src/service/user_service.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/streaming_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>(create: (_) => prefs),
        Provider<UserService>(create: (_) => UserService(domain)),
        Provider<CalendarService>(create: (_) => CalendarService(domain)),
        Provider<SocketService>(create: (_) => SocketService(domain)),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersState>(
            create: (context) => UsersState(
              context.read<UserService>(),
              context.read<SharedPreferences>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => CalendarState(context.read<CalendarService>()),
          ),
          ChangeNotifierProvider<StreamingState>(
            create: (context) => StreamingState(context.read<SocketService>()),
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
          routerConfig: router,
        ),
      ),
    ),
  );
}
