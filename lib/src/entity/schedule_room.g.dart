// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleRoomImpl _$$ScheduleRoomImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleRoomImpl(
      json['id'] as String,
      json['code'] as String,
      DateTime.parse(json['startTime'] as String),
      DateTime.parse(json['endTime'] as String),
      json['hostId'] as int,
      title: json['title'] as String? ?? '',
      users: (json['listParticipant'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ScheduleRoomImplToJson(_$ScheduleRoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.roomId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'hostId': instance.hostId,
      'title': instance.title,
      'listParticipant': instance.users,
    };
