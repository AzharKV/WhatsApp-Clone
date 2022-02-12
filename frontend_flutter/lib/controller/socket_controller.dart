import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp_clone/const_files/keys/server_keys.dart';
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';

class SocketController extends GetxController {
  late Socket socket;
  String token = "";

  Future<void> connectToSocket() async {
    token = await SharedPref().readString(SharedPrefKeys().authToken);

    socket = io(
        ServerKeys.socketBaseurl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setAuth({'token': token})
            .build());

    socket.onConnect((data) {
      debugPrint("Connected to socket $data");
      UserController userController = Get.put(UserController());
      userController.getMyDetails();
    });

    socket.onConnecting((data) => debugPrint("Connecting to socket $data"));

    socket.onError(_connectionError);
    socket.onConnectError(_connectionError);
    socket.onReconnectError(_connectionError);
  }

  void _connectionError(dynamic data) {
    debugPrint("socket connection error $data");
    //connectToSocket();
  }
}
