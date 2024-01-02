import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_join_user.freezed.dart';
part 'request_join_user.g.dart';

@freezed
class RequestJoinUser with _$RequestJoinUser {
  const RequestJoinUser._();

  const factory RequestJoinUser(
    @JsonKey(name: 'uid') final int userId, {
    @Default('') @JsonKey(name: 'username') final String name,
    @Default('') @JsonKey(name: 'avatar') final String avatar,
  }) = _RequestJoinUser;

  factory RequestJoinUser.fromJson(Map<String, Object?> json) =>
      _$RequestJoinUserFromJson(json);
}
