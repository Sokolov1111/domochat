import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;
  final _storage = FlutterSecureStorage();
  bool _isConnected = false;

  SocketService._internal();

  Future<void> connect() async {
    if (_isConnected) return;

    final token = await _storage.read(key: 'token') ?? '';
    socket = IO.io(
      'http://10.0.2.2:6102',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      print('Socket disconnected');
    });

    await socket.connect();
  }

  void disconnect() {
    socket.disconnect();
    _isConnected = false;
  }

  void onNewMessage(void Function(dynamic) handler) {
    socket.on('newMessage', handler);
  }

  void offNewMessage() {
    socket.off('newMessage');
  }
}