import 'package:freezed_annotation/freezed_annotation.dart';

part 'agora_room_info.freezed.dart';
part 'agora_room_info.g.dart';

@freezed
class AgoraRoomInfo with _$AgoraRoomInfo {
  const factory AgoraRoomInfo({
    @Default('') @JsonKey(name: 'appId') final String appId,
    @Default('') @JsonKey(name: 'code') final String channelName,
    @Default('') @JsonKey(name: 'rtcToken') final String token,
  }) = _AgoraRoomInfo;

  factory AgoraRoomInfo.fromJson(Map<String, Object?> json) =>
      _$AgoraRoomInfoFromJson(json);
}
