// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_join_room_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RequestJoinRoomUser {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  RequestJoinRoomStatus get requestJoinRoomStatus =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RequestJoinRoomUserCopyWith<RequestJoinRoomUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestJoinRoomUserCopyWith<$Res> {
  factory $RequestJoinRoomUserCopyWith(
          RequestJoinRoomUser value, $Res Function(RequestJoinRoomUser) then) =
      _$RequestJoinRoomUserCopyWithImpl<$Res, RequestJoinRoomUser>;
  @useResult
  $Res call({int id, String name, RequestJoinRoomStatus requestJoinRoomStatus});
}

/// @nodoc
class _$RequestJoinRoomUserCopyWithImpl<$Res, $Val extends RequestJoinRoomUser>
    implements $RequestJoinRoomUserCopyWith<$Res> {
  _$RequestJoinRoomUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? requestJoinRoomStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      requestJoinRoomStatus: null == requestJoinRoomStatus
          ? _value.requestJoinRoomStatus
          : requestJoinRoomStatus // ignore: cast_nullable_to_non_nullable
              as RequestJoinRoomStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestJoinRoomUserImplCopyWith<$Res>
    implements $RequestJoinRoomUserCopyWith<$Res> {
  factory _$$RequestJoinRoomUserImplCopyWith(_$RequestJoinRoomUserImpl value,
          $Res Function(_$RequestJoinRoomUserImpl) then) =
      __$$RequestJoinRoomUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, RequestJoinRoomStatus requestJoinRoomStatus});
}

/// @nodoc
class __$$RequestJoinRoomUserImplCopyWithImpl<$Res>
    extends _$RequestJoinRoomUserCopyWithImpl<$Res, _$RequestJoinRoomUserImpl>
    implements _$$RequestJoinRoomUserImplCopyWith<$Res> {
  __$$RequestJoinRoomUserImplCopyWithImpl(_$RequestJoinRoomUserImpl _value,
      $Res Function(_$RequestJoinRoomUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? requestJoinRoomStatus = null,
  }) {
    return _then(_$RequestJoinRoomUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      requestJoinRoomStatus: null == requestJoinRoomStatus
          ? _value.requestJoinRoomStatus
          : requestJoinRoomStatus // ignore: cast_nullable_to_non_nullable
              as RequestJoinRoomStatus,
    ));
  }
}

/// @nodoc

class _$RequestJoinRoomUserImpl implements _RequestJoinRoomUser {
  const _$RequestJoinRoomUserImpl(
      {required this.id,
      this.name = 'N/A',
      this.requestJoinRoomStatus = RequestJoinRoomStatus.unknown});

  @override
  final int id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final RequestJoinRoomStatus requestJoinRoomStatus;

  @override
  String toString() {
    return 'RequestJoinRoomUser(id: $id, name: $name, requestJoinRoomStatus: $requestJoinRoomStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestJoinRoomUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.requestJoinRoomStatus, requestJoinRoomStatus) ||
                other.requestJoinRoomStatus == requestJoinRoomStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, requestJoinRoomStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestJoinRoomUserImplCopyWith<_$RequestJoinRoomUserImpl> get copyWith =>
      __$$RequestJoinRoomUserImplCopyWithImpl<_$RequestJoinRoomUserImpl>(
          this, _$identity);
}

abstract class _RequestJoinRoomUser implements RequestJoinRoomUser {
  const factory _RequestJoinRoomUser(
          {required final int id,
          final String name,
          final RequestJoinRoomStatus requestJoinRoomStatus}) =
      _$RequestJoinRoomUserImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  RequestJoinRoomStatus get requestJoinRoomStatus;
  @override
  @JsonKey(ignore: true)
  _$$RequestJoinRoomUserImplCopyWith<_$RequestJoinRoomUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
