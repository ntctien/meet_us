// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agora_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AgoraUser {
  int get id => throw _privateConstructorUsedError;
  bool get isCameraOn => throw _privateConstructorUsedError;
  bool get isMicroOn => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AgoraUserCopyWith<AgoraUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgoraUserCopyWith<$Res> {
  factory $AgoraUserCopyWith(AgoraUser value, $Res Function(AgoraUser) then) =
      _$AgoraUserCopyWithImpl<$Res, AgoraUser>;
  @useResult
  $Res call({int id, bool isCameraOn, bool isMicroOn});
}

/// @nodoc
class _$AgoraUserCopyWithImpl<$Res, $Val extends AgoraUser>
    implements $AgoraUserCopyWith<$Res> {
  _$AgoraUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isCameraOn = null,
    Object? isMicroOn = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isCameraOn: null == isCameraOn
          ? _value.isCameraOn
          : isCameraOn // ignore: cast_nullable_to_non_nullable
              as bool,
      isMicroOn: null == isMicroOn
          ? _value.isMicroOn
          : isMicroOn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgoraUserImplCopyWith<$Res>
    implements $AgoraUserCopyWith<$Res> {
  factory _$$AgoraUserImplCopyWith(
          _$AgoraUserImpl value, $Res Function(_$AgoraUserImpl) then) =
      __$$AgoraUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, bool isCameraOn, bool isMicroOn});
}

/// @nodoc
class __$$AgoraUserImplCopyWithImpl<$Res>
    extends _$AgoraUserCopyWithImpl<$Res, _$AgoraUserImpl>
    implements _$$AgoraUserImplCopyWith<$Res> {
  __$$AgoraUserImplCopyWithImpl(
      _$AgoraUserImpl _value, $Res Function(_$AgoraUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isCameraOn = null,
    Object? isMicroOn = null,
  }) {
    return _then(_$AgoraUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isCameraOn: null == isCameraOn
          ? _value.isCameraOn
          : isCameraOn // ignore: cast_nullable_to_non_nullable
              as bool,
      isMicroOn: null == isMicroOn
          ? _value.isMicroOn
          : isMicroOn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AgoraUserImpl implements _AgoraUser {
  const _$AgoraUserImpl(
      {required this.id, required this.isCameraOn, required this.isMicroOn});

  @override
  final int id;
  @override
  final bool isCameraOn;
  @override
  final bool isMicroOn;

  @override
  String toString() {
    return 'AgoraUser(id: $id, isCameraOn: $isCameraOn, isMicroOn: $isMicroOn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgoraUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isCameraOn, isCameraOn) ||
                other.isCameraOn == isCameraOn) &&
            (identical(other.isMicroOn, isMicroOn) ||
                other.isMicroOn == isMicroOn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, isCameraOn, isMicroOn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgoraUserImplCopyWith<_$AgoraUserImpl> get copyWith =>
      __$$AgoraUserImplCopyWithImpl<_$AgoraUserImpl>(this, _$identity);
}

abstract class _AgoraUser implements AgoraUser {
  const factory _AgoraUser(
      {required final int id,
      required final bool isCameraOn,
      required final bool isMicroOn}) = _$AgoraUserImpl;

  @override
  int get id;
  @override
  bool get isCameraOn;
  @override
  bool get isMicroOn;
  @override
  @JsonKey(ignore: true)
  _$$AgoraUserImplCopyWith<_$AgoraUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
