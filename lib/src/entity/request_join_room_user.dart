import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_us/src/core/enum.dart';

part 'request_join_room_user.freezed.dart';

@freezed
class RequestJoinRoomUser with _$RequestJoinRoomUser {
  const factory RequestJoinRoomUser({
    required final int id,
    @Default('N/A') final String name,
    @Default(RequestJoinRoomStatus.unknown)
    RequestJoinRoomStatus requestJoinRoomStatus,
  }) = _RequestJoinRoomUser;
}
