import 'dart:convert';

import 'package:meet_us/src/core/const.dart';
import 'package:meet_us/src/core/http_base_service.dart';
import 'package:meet_us/src/entity/agora_room_info.dart';

class UserService extends HttpBaseService {
  UserService(super.domain);

  final String _getAgoraRoomInfoApi = '/room/token';

  Future<AgoraRoomInfo> getAgoraRoomInfo(int uid) async {
    final query = <String, String>{
      'code': defaultRoomId,
      'uid': '$uid',
      'role': 'publisher',
    };
    final response = await get(_getAgoraRoomInfoApi, queryParameters: query);

    if (response.statusCode != 200) {
      throw Exception("Can't get agora room info");
    }

    final jsonBody = jsonDecode(response.body);
    final String token = jsonBody['rtcToken'] ?? '';
    if (token.isEmpty) {
      throw Exception("Can't get agora room info");
    }

    return AgoraRoomInfo(
      appId: agoraAppId,
      channelName: defaultRoomId,
      token: jsonBody['rtcToken'],
    );
  }
}
