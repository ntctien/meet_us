import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User(
    @JsonKey(name: 'id') final String uid,
    @JsonKey(name: 'userId') final int id,
    @JsonKey(name: 'email') final String email, {
    @Default('') @JsonKey(name: 'name') final String name,
    @Default('') @JsonKey(name: 'avatar') final String avatar,
    @Default('') String token,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  String get displayName {
    return name.isNotEmpty ? name : email;
  }
}
