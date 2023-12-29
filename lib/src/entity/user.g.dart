// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      json['id'] as String,
      json['userId'] as int,
      json['email'] as String,
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.uid,
      'userId': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
      'token': instance.token,
    };
