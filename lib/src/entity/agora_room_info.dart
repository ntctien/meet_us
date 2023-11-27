import 'package:freezed_annotation/freezed_annotation.dart';

part 'agora_room_info.freezed.dart';

@freezed
class AgoraRoomInfo with _$AgoraRoomInfo {
  const factory AgoraRoomInfo({
    required final String appId,
    required final String channelName,
    required final String token,
  }) = _AgoraRoomInfo;
}
