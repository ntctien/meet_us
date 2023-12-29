import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/message.dart';
import 'package:meet_us/src/service/socket_service.dart';

class MessageState extends ChangeNotifier {
  final SocketService _socketService;

  MessageState(this._socketService) {
    _socketService.onReceiveMessage = _onReceiveMessage;
  }

  final _messagesByRoomId = <String, List<Message>>{};
  UnmodifiableListView<Message> messagesByRoomId(String roomId) =>
      UnmodifiableListView(_messagesByRoomId[roomId] ?? []);
  String? _currentRoomId;
  String? get currentRoomId => _currentRoomId;

  void initializeSocket(String token, String userName) {
    _socketService.initializeSocket(token, userName);
  }

  void disposeSocket() {
    _socketService.dispose();
  }

  void _onReceiveMessage(dynamic value) {
    if (currentRoomId == null) {
      return;
    }
    final message = Message.fromJson(value);
    final messages = _messagesByRoomId[_currentRoomId!] ?? <Message>[];
    messages.add(message);
    _messagesByRoomId[_currentRoomId!] = messages;
    notifyListeners();
  }

  void joinRoom(String roomId) {
    _socketService.emit('joinRoom', <String, String>{'code': roomId});
    _currentRoomId = roomId;
  }

  void leaveRoom(String roomId) {
    _socketService.emit('leaveRoom', roomId);
    _currentRoomId = null;
  }

  void sendMessage(String roomId, String content) {
    _socketService.emit('message', <String, String>{
      'code': roomId,
      'message': content,
    });
  }

  void clearMessagesByRoomId(String roomId) {
    if (_messagesByRoomId[roomId] != null) {
      _messagesByRoomId.remove(roomId);
      notifyListeners();
    }
  }
}
