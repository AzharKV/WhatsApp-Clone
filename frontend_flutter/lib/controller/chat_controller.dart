import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/socket_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/models/user/user_status_model.dart';
import 'package:whatsapp_clone/repository/chat_repository.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/utility/utility.dart';

import '../models/message/messageModel.dart';

class ChatController extends GetxController {
  SocketController socketController = Get.find<SocketController>();
  UserController userController = Get.find<UserController>();

  UserRepository userRepository = UserRepository();
  ChatRepository chatRepository = ChatRepository();

  RxBool userStatus = false.obs;

  RxList message = [].obs;

  TextEditingController messageTextField = TextEditingController();

  Future<void> checkUserStatus(String id) async {
    var result = await userRepository.getUserStatus(id);

    try {
      if (result.runtimeType.toString() == 'UserStatusModel') {
        UserStatusModel data = result;

        userStatus.value = data.userData?.status ?? false;
      } else {
        Utility.httpResponseValidation(result);
      }
    } catch (e) {
      debugPrint("error usersList $e");
    }

    try {
      String eventString = '/user_status' + id;

      socketController.socket
          .on(eventString, (data) => userStatus.value = data ?? false);
    } catch (e) {
      debugPrint("status socket error $e");
    }
  }

  Future<void> sendMessage(String userId) async {
    MessageModel body = MessageModel(
        message: messageTextField.text,
        date: DateTime.now(),
        from: userController.userId.value,
        to: userId);

    chatRepository.sendMessage(body.toMap());

    message.insert(0, body);

    messageTextField.text = "";
  }

  @override
  void onInit() {
    messageTextField.text = "";
    messageTextField.clear();

    socketController.socket.on("message", (data) {
      MessageModel messageModel = MessageModel.fromMap(data);

      message.insert(0, messageModel);
    });

    super.onInit();
  }

  @override
  void dispose() {
    messageTextField.dispose();
    super.dispose();
  }
}
