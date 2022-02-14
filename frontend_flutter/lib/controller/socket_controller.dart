import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/keys/server_keys.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/databse/db_models/db_message_model.dart';
import 'package:whatsapp_clone/models/message/messageModel.dart';
import 'package:whatsapp_clone/repository/chat_repository.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';

import '../const_files/keys/shared_pref_keys.dart';

class SocketController extends GetxController {
  Box messageBox = Hive.box<DbMessageModel>(DbNames.message);

  ChatRepository chatRepository = ChatRepository();

  late Socket socket;
  String token = "";

  Future<void> connectToSocket() async {
    token = await SharedPref().readString(SharedPrefKeys.authToken);

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
      ChatController chatController = Get.put(ChatController());
      userController.getMyDetails();
      chatController.pendingMessageCheck();
    });

    //receive new messages
    socket.on("message", message);

    //update message received
    socket.on("messageReceived", messageReceived);

    //update message opened
    socket.on("messageOpened", messageOpened);

    socket.onConnecting((data) => debugPrint("Connecting to socket $data"));

    socket.onError(_connectionError);
    socket.onConnectError(_connectionError);
    socket.onReconnectError(_connectionError);
  }

  void _connectionError(dynamic data) {
    debugPrint("socket connection error $data");
    //connectToSocket();
  }

  Future<void> message(dynamic data) async {
    MessageModel messageModel = MessageModel.fromMap(data);

    DateTime currentDateTime = DateTime.now();

    DbMessageModel dbMessageModel = DbMessageModel(
      id: messageModel.id!,
      message: messageModel.message!,
      from: messageModel.from!,
      to: messageModel.to!,
      createdAt: messageModel.createdAt!,
      receivedAt: currentDateTime,
      openedAt: messageModel.openedAt,
      messageType: messageModel.messageType,
      filePath: messageModel.filePath,
    );

    messageBox.put(messageModel.id, dbMessageModel);

    chatRepository.receivedMessageUpdate({
      "id": messageModel.id,
      "receivedAt": currentDateTime.toIso8601String()
    });
  }

  void messageReceived(data) {
    String messageId = data["messageId"];
    DateTime receivedDate = DateTime.parse(data["receivedAt"]);

    DbMessageModel messageData = messageBox.get(messageId);

    messageData.receivedAt = receivedDate;

    messageBox.put(messageId, messageData);
  }

  void messageOpened(data) {
    String messageId = data["messageId"];
    DateTime openedDate = DateTime.parse(data["openedAt"]);

    DbMessageModel messageData = messageBox.get(messageId);

    messageData.openedAt = openedDate;

    messageBox.put(messageId, messageData);
  }
}
