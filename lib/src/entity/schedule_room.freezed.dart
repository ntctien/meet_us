// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ScheduleRoom _$ScheduleRoomFromJson(Map<String, dynamic> json) {
  return _ScheduleRoom.fromJson(json);
}

/// @nodoc
mixin _$ScheduleRoom {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'code')
  String get roomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'startTime')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'endTime')
  DateTime get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'hostId')
  int get hostId => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'listParticipant')
  List<User> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleRoomCopyWith<ScheduleRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleRoomCopyWith<$Res> {
  factory $ScheduleRoomCopyWith(
          ScheduleRoom value, $Res Function(ScheduleRoom) then) =
      _$ScheduleRoomCopyWithImpl<$Res, ScheduleRoom>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'code') String roomId,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      @JsonKey(name: 'hostId') int hostId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'listParticipant') List<User> users});
}

/// @nodoc
class _$ScheduleRoomCopyWithImpl<$Res, $Val extends ScheduleRoom>
    implements $ScheduleRoomCopyWith<$Res> {
  _$ScheduleRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? hostId = null,
    Object? title = null,
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<User>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleRoomImplCopyWith<$Res>
    implements $ScheduleRoomCopyWith<$Res> {
  factory _$$ScheduleRoomImplCopyWith(
          _$ScheduleRoomImpl value, $Res Function(_$ScheduleRoomImpl) then) =
      __$$ScheduleRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'code') String roomId,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      @JsonKey(name: 'hostId') int hostId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'listParticipant') List<User> users});
}

/// @nodoc
class __$$ScheduleRoomImplCopyWithImpl<$Res>
    extends _$ScheduleRoomCopyWithImpl<$Res, _$ScheduleRoomImpl>
    implements _$$ScheduleRoomImplCopyWith<$Res> {
  __$$ScheduleRoomImplCopyWithImpl(
      _$ScheduleRoomImpl _value, $Res Function(_$ScheduleRoomImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? hostId = null,
    Object? title = null,
    Object? users = null,
  }) {
    return _then(_$ScheduleRoomImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<User>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleRoomImpl extends _ScheduleRoom {
  const _$ScheduleRoomImpl(
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'code') this.roomId,
      @JsonKey(name: 'startTime') this.startTime,
      @JsonKey(name: 'endTime') this.endTime,
      @JsonKey(name: 'hostId') this.hostId,
      {@JsonKey(name: 'title') this.title = '',
      @JsonKey(name: 'listParticipant') final List<User> users = const []})
      : _users = users,
        super._();

  factory _$ScheduleRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleRoomImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'code')
  final String roomId;
  @override
  @JsonKey(name: 'startTime')
  final DateTime startTime;
  @override
  @JsonKey(name: 'endTime')
  final DateTime endTime;
  @override
  @JsonKey(name: 'hostId')
  final int hostId;
  @override
  @JsonKey(name: 'title')
  final String title;
  final List<User> _users;
  @override
  @JsonKey(name: 'listParticipant')
  List<User> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'ScheduleRoom(id: $id, roomId: $roomId, startTime: $startTime, endTime: $endTime, hostId: $hostId, title: $title, users: $users)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleRoomImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, roomId, startTime, endTime,
      hostId, title, const DeepCollectionEquality().hash(_users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleRoomImplCopyWith<_$ScheduleRoomImpl> get copyWith =>
      __$$ScheduleRoomImplCopyWithImpl<_$ScheduleRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleRoomImplToJson(
      this,
    );
  }
}

abstract class _ScheduleRoom extends ScheduleRoom {
  const factory _ScheduleRoom(
          @JsonKey(name: 'id') final String id,
          @JsonKey(name: 'code') final String roomId,
          @JsonKey(name: 'startTime') final DateTime startTime,
          @JsonKey(name: 'endTime') final DateTime endTime,
          @JsonKey(name: 'hostId') final int hostId,
          {@JsonKey(name: 'title') final String title,
          @JsonKey(name: 'listParticipant') final List<User> users}) =
      _$ScheduleRoomImpl;
  const _ScheduleRoom._() : super._();

  factory _ScheduleRoom.fromJson(Map<String, dynamic> json) =
      _$ScheduleRoomImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'code')
  String get roomId;
  @override
  @JsonKey(name: 'startTime')
  DateTime get startTime;
  @override
  @JsonKey(name: 'endTime')
  DateTime get endTime;
  @override
  @JsonKey(name: 'hostId')
  int get hostId;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'listParticipant')
  List<User> get users;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleRoomImplCopyWith<_$ScheduleRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
