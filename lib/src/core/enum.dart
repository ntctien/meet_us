enum RoomConnectionStatus {
  connecting,
  connected,
  disconnected,
}

enum RequestJoinRoomStatus {
  unknown('UNKNOWN'),
  approved('APPROVE'),
  waiting('WAITING'),
  decline('DECLINE');

  const RequestJoinRoomStatus(this.value);

  final String value;
}
