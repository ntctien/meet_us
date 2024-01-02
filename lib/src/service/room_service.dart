import 'dart:convert';

import 'package:meet_us/src/core/enum.dart';
import 'package:meet_us/src/core/http_base_service.dart';
import 'package:meet_us/src/entity/request_join_user.dart';

class RoomService extends HttpBaseService {
  RoomService(super.domain);

  final String _requestJoinRoomApi = '/room/join';
  final String _replyJoinRequestApi = '/room/replyJoinRequest';
  String _getRequestJoinRoomUsersApi(String code) => '/room/requestUsers/$code';

  Future<List<RequestJoinUser>> getRequestJoinRoomUsers(String code) async {
    final response = await get(_getRequestJoinRoomUsersApi(code));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'External server error';
    }

    final jsonResponse = json.decode(response.body);
    final users = <RequestJoinUser>[];
    for (final user in jsonResponse) {
      users.add(RequestJoinUser.fromJson(user));
    }
    return users;
  }

  Future<RequestJoinRoomStatus> requestJoinRoom(String code) async {
    final body = <String, dynamic>{'code': code};
    final response = await post(_requestJoinRoomApi, body: json.encode(body));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'External server error';
    }

    final jsonResponse = json.decode(response.body);
    final statusString = jsonResponse['status'];
    RequestJoinRoomStatus status = RequestJoinRoomStatus.unknown;
    switch (statusString) {
      case 'APPROVE':
        status = RequestJoinRoomStatus.approved;
        break;
      case 'WAITING':
        status = RequestJoinRoomStatus.waiting;
        break;
      case 'DECLINE':
        status = RequestJoinRoomStatus.decline;
        break;
    }
    return status;
  }

  Future<void> replyJoinRequest(
    String code,
    int userId,
    bool acceptance,
  ) async {
    final body = <String, dynamic>{
      'uid': userId,
      'code': code,
      'accept': acceptance,
    };
    final response = await post(_replyJoinRequestApi, body: json.encode(body));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'External server error';
    }
  }
}
