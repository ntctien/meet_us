// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agora_room_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AgoraRoomInfo {
  String get appId => throw _privateConstructorUsedError;
  String get channelName => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AgoraRoomInfoCopyWith<AgoraRoomInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgoraRoomInfoCopyWith<$Res> {
  factory $AgoraRoomInfoCopyWith(
          AgoraRoomInfo value, $Res Function(AgoraRoomInfo) then) =
      _$AgoraRoomInfoCopyWithImpl<$Res, AgoraRoomInfo>;
  @useResult
  $Res call({String appId, String channelName, String token});
}

/// @nodoc
class _$AgoraRoomInfoCopyWithImpl<$Res, $Val extends AgoraRoomInfo>
    implements $AgoraRoomInfoCopyWith<$Res> {
  _$AgoraRoomInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? channelName = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgoraRoomInfoImplCopyWith<$Res>
    implements $AgoraRoomInfoCopyWith<$Res> {
  factory _$$AgoraRoomInfoImplCopyWith(
          _$AgoraRoomInfoImpl value, $Res Function(_$AgoraRoomInfoImpl) then) =
      __$$AgoraRoomInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String appId, String channelName, String token});
}

/// @nodoc
class __$$AgoraRoomInfoImplCopyWithImpl<$Res>
    extends _$AgoraRoomInfoCopyWithImpl<$Res, _$AgoraRoomInfoImpl>
    implements _$$AgoraRoomInfoImplCopyWith<$Res> {
  __$$AgoraRoomInfoImplCopyWithImpl(
      _$AgoraRoomInfoImpl _value, $Res Function(_$AgoraRoomInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? channelName = null,
    Object? token = null,
  }) {
    return _then(_$AgoraRoomInfoImpl(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AgoraRoomInfoImpl implements _AgoraRoomInfo {
  const _$AgoraRoomInfoImpl(
      {required this.appId, required this.channelName, required this.token});

  @override
  final String appId;
  @override
  final String channelName;
  @override
  final String token;

  @override
  String toString() {
    return 'AgoraRoomInfo(appId: $appId, channelName: $channelName, token: $token)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgoraRoomInfoImpl &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appId, channelName, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgoraRoomInfoImplCopyWith<_$AgoraRoomInfoImpl> get copyWith =>
      __$$AgoraRoomInfoImplCopyWithImpl<_$AgoraRoomInfoImpl>(this, _$identity);
}

abstract class _AgoraRoomInfo implements AgoraRoomInfo {
  const factory _AgoraRoomInfo(
      {required final String appId,
      required final String channelName,
      required final String token}) = _$AgoraRoomInfoImpl;

  @override
  String get appId;
  @override
  String get channelName;
  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$AgoraRoomInfoImplCopyWith<_$AgoraRoomInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
