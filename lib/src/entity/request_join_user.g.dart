// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_join_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestJoinUserImpl _$$RequestJoinUserImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestJoinUserImpl(
      json['uid'] as int,
      name: json['username'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );

Map<String, dynamic> _$$RequestJoinUserImplToJson(
        _$RequestJoinUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.userId,
      'username': instance.name,
      'avatar': instance.avatar,
    };
