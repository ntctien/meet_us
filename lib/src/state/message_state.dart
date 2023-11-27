import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meet_us/src/core/const.dart';
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

  void initializeSocket(String userName) {
    _socketService.initializeSocket(userName);
  }

  void disposeSocket() {
    _socketService.dispose();
  }

  void _onReceiveMessage(dynamic value) {
    final message = Message.fromJson(value);
    final messages = _messagesByRoomId[defaultRoomId] ?? <Message>[];
    messages.add(message);
    _messagesByRoomId[defaultRoomId] = messages;
    notifyListeners();
  }

  void sendMessage(String roomId, String content) {
    _socketService.emit('message', content);
  }

  void clearMessagesByRoomId(String roomId) {
    if (_messagesByRoomId[roomId] != null) {
      _messagesByRoomId.remove(roomId);
      notifyListeners();
    }
  }
}
