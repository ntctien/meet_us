import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late final String _domain;
  late final Socket _socket;

  SocketService(this._domain);

  void initializeSocket(String name) {
    _socket = io(
        'https://$_domain',
        OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({
              'name': name,
            })
            .disableAutoConnect()
            .enableForceNew()
            .build());
    _socket.connect();
    _socket.onConnect((data) {
      print('_socket connected');
    });
    _socket.on('onMessage', (data) => onReceiveMessage(data));
  }

  void dispose() {
    _socket.disconnect();
  }

  Function onReceiveMessage = (dynamic data) {};

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }
}
