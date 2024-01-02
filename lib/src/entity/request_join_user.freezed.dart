// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_join_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RequestJoinUser _$RequestJoinUserFromJson(Map<String, dynamic> json) {
  return _RequestJoinUser.fromJson(json);
}

/// @nodoc
mixin _$RequestJoinUser {
  @JsonKey(name: 'uid')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  String get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequestJoinUserCopyWith<RequestJoinUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestJoinUserCopyWith<$Res> {
  factory $RequestJoinUserCopyWith(
          RequestJoinUser value, $Res Function(RequestJoinUser) then) =
      _$RequestJoinUserCopyWithImpl<$Res, RequestJoinUser>;
  @useResult
  $Res call(
      {@JsonKey(name: 'uid') int userId,
      @JsonKey(name: 'username') String name,
      @JsonKey(name: 'avatar') String avatar});
}

/// @nodoc
class _$RequestJoinUserCopyWithImpl<$Res, $Val extends RequestJoinUser>
    implements $RequestJoinUserCopyWith<$Res> {
  _$RequestJoinUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? avatar = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestJoinUserImplCopyWith<$Res>
    implements $RequestJoinUserCopyWith<$Res> {
  factory _$$RequestJoinUserImplCopyWith(_$RequestJoinUserImpl value,
          $Res Function(_$RequestJoinUserImpl) then) =
      __$$RequestJoinUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'uid') int userId,
      @JsonKey(name: 'username') String name,
      @JsonKey(name: 'avatar') String avatar});
}

/// @nodoc
class __$$RequestJoinUserImplCopyWithImpl<$Res>
    extends _$RequestJoinUserCopyWithImpl<$Res, _$RequestJoinUserImpl>
    implements _$$RequestJoinUserImplCopyWith<$Res> {
  __$$RequestJoinUserImplCopyWithImpl(
      _$RequestJoinUserImpl _value, $Res Function(_$RequestJoinUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? avatar = null,
  }) {
    return _then(_$RequestJoinUserImpl(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestJoinUserImpl extends _RequestJoinUser {
  const _$RequestJoinUserImpl(@JsonKey(name: 'uid') this.userId,
      {@JsonKey(name: 'username') this.name = '',
      @JsonKey(name: 'avatar') this.avatar = ''})
      : super._();

  factory _$RequestJoinUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestJoinUserImplFromJson(json);

  @override
  @JsonKey(name: 'uid')
  final int userId;
  @override
  @JsonKey(name: 'username')
  final String name;
  @override
  @JsonKey(name: 'avatar')
  final String avatar;

  @override
  String toString() {
    return 'RequestJoinUser(userId: $userId, name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestJoinUserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, name, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestJoinUserImplCopyWith<_$RequestJoinUserImpl> get copyWith =>
      __$$RequestJoinUserImplCopyWithImpl<_$RequestJoinUserImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestJoinUserImplToJson(
      this,
    );
  }
}

abstract class _RequestJoinUser extends RequestJoinUser {
  const factory _RequestJoinUser(@JsonKey(name: 'uid') final int userId,
      {@JsonKey(name: 'username') final String name,
      @JsonKey(name: 'avatar') final String avatar}) = _$RequestJoinUserImpl;
  const _RequestJoinUser._() : super._();

  factory _RequestJoinUser.fromJson(Map<String, dynamic> json) =
      _$RequestJoinUserImpl.fromJson;

  @override
  @JsonKey(name: 'uid')
  int get userId;
  @override
  @JsonKey(name: 'username')
  String get name;
  @override
  @JsonKey(name: 'avatar')
  String get avatar;
  @override
  @JsonKey(ignore: true)
  _$$RequestJoinUserImplCopyWith<_$RequestJoinUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
