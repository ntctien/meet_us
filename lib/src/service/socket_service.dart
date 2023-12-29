import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late final String _domain;
  Socket? _socket;

  SocketService(this._domain);

  void initializeSocket(String token, String name) {
    dispose();
    _socket = io(
        'http://$_domain',
        OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders(<String, String>{'authorization': 'Bearer $token'})
            .setQuery({'name': name})
            .disableAutoConnect()
            .enableForceNew()
            .build());
    _socket?.connect();
    _socket?.on('onMessage', (data) => onReceiveMessage(data));
    _socket?.on('onRequest', (data) => onReceiveRequestJoinRoom(data));
  }

  void dispose() {
    _socket?.disconnect();
    _socket = null;
  }

  Function onReceiveMessage = (dynamic data) {};

  Function onReceiveRequestJoinRoom = (dynamic data) {};

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }
}
