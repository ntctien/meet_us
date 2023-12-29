import 'dart:convert';

import 'package:meet_us/src/core/http_base_service.dart';
import 'package:meet_us/src/entity/schedule_room.dart';

class CalendarService extends HttpBaseService {
  CalendarService(super.domain);

  final String _createScheduleRoomApi = '/room/create';
  final String _getScheduleRoomApi = '/room/list';

  Future<void> createLiveRoom(
    String title,
    DateTime startTime,
    DateTime endTime,
    List<String> participantIds,
  ) async {
    final body = <String, dynamic>{
      'title': title,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'listUserIds': participantIds,
    };
    final response =
        await post(_createScheduleRoomApi, body: json.encode(body));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'External server error';
    }
  }

  Future<List<ScheduleRoom>> getLiveRooms(DateTime date) async {
    final body = <String, int>{
      'timestamp': date.millisecondsSinceEpoch,
    };
    final response = await post(_getScheduleRoomApi, body: json.encode(body));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'External server error';
    }

    final jsonResponse = jsonDecode(response.body);
    final rooms = <ScheduleRoom>[];
    for (final room in jsonResponse) {
      rooms.add(ScheduleRoom.fromJson(room));
    }
    return rooms;
  }
}
