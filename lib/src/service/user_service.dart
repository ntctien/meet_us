import 'dart:convert';

import 'package:meet_us/src/core/const.dart';
import 'package:meet_us/src/core/http_base_service.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';
import 'package:meet_us/src/entity/user.dart';

class UserService extends HttpBaseService {
  UserService(super.domain);

  final String _signInApi = '/auth/signin';
  final String _signUpApi = '/auth/signup';
  final String _getOwnerUserInfoApi = '/user/me';
  final String _getUserByUidApi = '/user/search-by-uid';
  final String _getAgoraRoomInfoApi = '/room/token';
  final String _searchUsersByKeywordApi = '/user/search';
  final String _searchUserByIdApi = '/user/searchByUid';
  final String _updateUserProfileApi = '/user/updateProfile';
  final String _changePasswordApi = '/user/changePassword';

  Future<String> signIn(String email, String password) async {
    final body = <String, String>{'email': email, 'password': password};
    final response = await post(_signInApi, body: json.encode(body));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);

    final String token = jsonResponse['access_token'];
    if (token.isEmpty) {
      throw 'Internal server error';
    }

    return token;
  }

  Future<String> signUp(String email, String password, String name) async {
    final body = <String, String>{
      'email': email,
      'password': password,
      'name': name,
    };
    final response = await post(_signUpApi, body: json.encode(body));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);

    final String token = jsonResponse['access_token'];
    if (token.isEmpty) {
      throw 'Internal server error';
    }

    return token;
  }

  Future<User> getOwnerUserInfo() async {
    final response = await get(_getOwnerUserInfoApi);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);
    final user = User.fromJson(jsonResponse);

    return user;
  }

  Future<User> getUserByUid(int uid) async {
    final response = await get(
      _getUserByUidApi,
      queryParameters: <String, String>{'uid': '$uid'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);
    return User.fromJson(jsonResponse);
  }

  Future<void> updateUserProfile(User user, {String? imagePath}) async {
    final body = <String, String>{'name': user.name};
    final mediasPath = <String>[];
    if (imagePath != null) {
      mediasPath.add(imagePath);
    }
    final response = await patchWithMedia(
      _updateUserProfileApi,
      body: body,
      mediasPath: mediasPath,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'External server error';
    }
  }

  Future<void> changePassword(
    String oldPass,
    String newPass,
    String confirmPass,
  ) async {
    final body = <String, String>{
      'oldPass': oldPass,
      'newPass': newPass,
      'confirmPass': confirmPass,
    };
    final response = await patch(
      _changePasswordApi,
      body: json.encode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }
  }

  Future<List<User>> searchUsersByKeyword(String keyword) async {
    final query = <String, String>{'name': keyword};
    final response = await get(
      _searchUsersByKeywordApi,
      queryParameters: query,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);
    final users = <User>[];
    for (final userJson in jsonResponse) {
      users.add(User.fromJson(userJson));
    }
    return users;
  }

  Future<User> searchUserById(int id) async {
    final query = <String, String>{'uid': '$id'};
    final response = await get(
      _searchUserByIdApi,
      queryParameters: query,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = jsonDecode(response.body);
      throw json['message'] ?? 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);
    return User.fromJson(jsonResponse);
  }

  Future<AgoraRoomInfo> getAgoraRoomInfo(int uid, {String? roomId}) async {
    final query = <String, String>{
      'uid': '$uid',
      'role': 'publisher',
    };
    if (roomId != null) {
      query['code'] = roomId;
    }
    final response = await get(_getAgoraRoomInfoApi, queryParameters: query);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Can't get agora room info";
    }

    final jsonResponse = jsonDecode(response.body);
    final roomInfo = AgoraRoomInfo.fromJson(jsonResponse);
    if (roomInfo.token.isEmpty || roomInfo.channelName.isEmpty) {
      throw "Can't get agora room info";
    }

    return roomInfo.copyWith(appId: agoraAppId);
  }
}
