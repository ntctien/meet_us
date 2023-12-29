// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_room_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgoraRoomInfoImpl _$$AgoraRoomInfoImplFromJson(Map<String, dynamic> json) =>
    _$AgoraRoomInfoImpl(
      appId: json['appId'] as String? ?? '',
      channelName: json['code'] as String? ?? '',
      token: json['rtcToken'] as String? ?? '',
    );

Map<String, dynamic> _$$AgoraRoomInfoImplToJson(_$AgoraRoomInfoImpl instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'code': instance.channelName,
      'rtcToken': instance.token,
    };
