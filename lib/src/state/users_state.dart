import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/service/user_service.dart';

class UsersState extends ChangeNotifier {
  final UserService _userService;

  UsersState(this._userService);

  User? _user;
  User? get user => _user;

  final _users = <int, User>{};
  UnmodifiableMapView<int, User> get users => UnmodifiableMapView(_users);

  Future<void> login(String email, String password) async {
    _user = User(id: 0, email: email);
    return;
  }

  Future<void> createAccount(String email, String password) async {
    _user = User(id: 0, email: email);
    return;
  }

  Future<AgoraRoomInfo> getAgoraRoomInfo() async {
    final roomInfo = await _userService.getAgoraRoomInfo(_user!.id);
    return roomInfo;
  }
}
