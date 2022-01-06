import 'package:flutter/material.dart';
import 'package:frontend_flutter/const_files/keys/server_keys.dart';
import 'package:frontend_flutter/const_files/keys/shared_pref_keys.dart';
import 'package:frontend_flutter/services/shared_pref.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketConnection {
  late Socket socket;
  String token = "";

  Future<void> connectToSocket() async {
    token = await SharedPref().readString(SharedPrefKeys().authToken);

    socket = io(
        ServerKeys().baseUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setAuth({'token': token})
            .build());

    socket.onConnect((data) => debugPrint("Connected to socket $data"));

    socket.onConnecting((data) => debugPrint("Connecting to socket $data"));

    socket.onError(_connectionError);
    socket.onConnectError(_connectionError);
    socket.onReconnectError(_connectionError);
  }

  void _connectionError(dynamic data) {
    debugPrint("socket connection error $data");
    connectToSocket();
  }
}
