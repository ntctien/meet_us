import 'package:freezed_annotation/freezed_annotation.dart';

part 'agora_user.freezed.dart';

@freezed
class AgoraUser with _$AgoraUser {
  const factory AgoraUser({
    required final int id,
    required final bool isCameraOn,
    required final bool isMicroOn,
  }) = _AgoraUser;
}
