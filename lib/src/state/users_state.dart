import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meet_us/src/core/const.dart';
import 'package:meet_us/src/core/http_base_service.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersState extends ChangeNotifier {
  final UserService _userService;
  final SharedPreferences _prefsService;

  UsersState(this._userService, this._prefsService);

  User? _user;
  User? get user => _user;

  Map<int, User> _users = <int, User>{};
  UnmodifiableMapView<int, User> get users => UnmodifiableMapView(_users);

  String? getAccessToken() {
    return _prefsService.getString(tokenKey);
  }

  Future<void> initAuthenticationStateFirstOpenApp(String token) async {
    HttpBaseService.baseHeaders['Authorization'] = 'Bearer $token';
    final user = await _userService.getOwnerUserInfo();
    _user = user.copyWith(token: token);
  }

  Future<void> resetAuthenticationState() async {
    _user = null;
    HttpBaseService.baseHeaders.clear();
    await _prefsService.remove(tokenKey);
  }

  Future<void> login(String email, String password) async {
    final token = await _userService.signIn(email, password);
    HttpBaseService.baseHeaders['Authorization'] = 'Bearer $token';
    final user = await _userService.getOwnerUserInfo();
    _user = user.copyWith(token: token);
    await _prefsService.setString(tokenKey, token);
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _prefsService.remove(tokenKey);
  }

  Future<void> createAccount(
    String email,
    String password,
    String name,
  ) async {
    final token = await _userService.signUp(email, password, name);
    HttpBaseService.baseHeaders['Authorization'] = 'Bearer $token';
    final user = await _userService.getOwnerUserInfo();
    _user = user.copyWith(token: token);
    await _prefsService.setString(tokenKey, token);
    notifyListeners();
  }

  Future<void> updateUserProfile(User user, {String? imagePath}) async {
    await _userService.updateUserProfile(user, imagePath: imagePath);
    _user = user;
    notifyListeners();
  }

  Future<void> changePassword(
    String oldPass,
    String newPass,
    String confirmPass,
  ) {
    return _userService.changePassword(oldPass, newPass, confirmPass);
  }

  Future<AgoraRoomInfo> getAgoraRoomInfo({String? roomId}) async {
    final roomInfo = await _userService.getAgoraRoomInfo(
      _user!.id,
      roomId: roomId,
    );
    return roomInfo;
  }

  Future<List<User>> searchUsersByKeyword(String keyword) {
    return _userService.searchUsersByKeyword(keyword);
  }

  Future<User> getUserInfoById(int id) async {
    final user = await _userService.searchUserById(id);
    final mapUser = Map<int, User>.from(_users);
    mapUser[user.id] = user;
    _users = mapUser;
    notifyListeners();
    return user;
  }
}
