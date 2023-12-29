import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_us/src/entity/user.dart';

part 'schedule_room.freezed.dart';
part 'schedule_room.g.dart';

@freezed
class ScheduleRoom with _$ScheduleRoom {
  const ScheduleRoom._();

  const factory ScheduleRoom(
    @JsonKey(name: 'id') final String id,
    @JsonKey(name: 'code') final String roomId,
    @JsonKey(name: 'startTime') final DateTime startTime,
    @JsonKey(name: 'endTime') final DateTime endTime,
    @JsonKey(name: 'hostId') final int hostId, {
    @Default('') @JsonKey(name: 'title') final String title,
    @Default([]) @JsonKey(name: 'users') final List<User> users,
  }) = _ScheduleRoom;

  factory ScheduleRoom.fromJson(Map<String, Object?> json) =>
      _$ScheduleRoomFromJson(json);

  String get key {
    return '${startTime.day}-${startTime.month}-${startTime.year}';
  }
}
