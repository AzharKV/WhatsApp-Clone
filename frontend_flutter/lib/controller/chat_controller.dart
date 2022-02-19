import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/controller/socket_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/databse/db_models/db_message_model.dart';
import 'package:whatsapp_clone/databse/db_models/db_pending_message_model.dart';
import 'package:whatsapp_clone/models/message/messageModel.dart';
import 'package:whatsapp_clone/models/user/user_status_model.dart';
import 'package:whatsapp_clone/repository/chat_repository.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/utility/utility.dart';

enum messageType { text, audio, image, video, document }

class ChatController extends GetxController {
  SocketController socketController = Get.find<SocketController>();
  UserController userController = Get.find<UserController>();

  UserRepository userRepository = UserRepository();
  ChatRepository chatRepository = ChatRepository();

  Box<DbMessageModel> messageBox = Hive.box<DbMessageModel>(DbNames.message);
  Box<DbPendingMessageModel> pendingMessageBox =
      Hive.box<DbPendingMessageModel>(DbNames.pendingMessage);

  RxBool userStatus = false.obs;

  TextEditingController messageTextField = TextEditingController();

  RxString textControllerValue = "".obs;

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
    if (messageTextField.text.isEmpty)
      sendVoice();
    else
      sendTextMessage(userId);
  }

  Future<void> sendVoice() async {}

  Future<void> sendTextMessage(String userId) async {
    //unique message id generation by from user and to user id with current time microsecondsSinceEpoch
    String messageId =
        "${userController.userId.value}$userId${DateTime.now().microsecondsSinceEpoch}";

    String messageText = messageTextField.text;
    messageTextField.text = "";
    textControllerValue.value = "";

    DateTime currentDate = DateTime.now();

    DbMessageModel data = DbMessageModel(
      id: messageId,
      message: messageText,
      from: userController.userId.value,
      to: userId,
      createdAt: currentDate,
      receivedAt: null,
      openedAt: null,
      messageType: "text",
      filePath: "",
    );

    DbPendingMessageModel pendingMessageModel =
        DbPendingMessageModel(messageId);

    messageBox.put(messageId, data);
    pendingMessageBox.put(messageId, pendingMessageModel);

    MessageModel body = MessageModel(
      id: messageId,
      message: messageText,
      from: userController.userId.value,
      to: userId,
      createdAt: currentDate,
      messageType: "text",
    );

    var response = await chatRepository.sendMessage(body.toMap());

    if (response.runtimeType.toString() == "Response")
      pendingMessageBox.delete(messageId);
  }

  void openedMessageUpdate(String id) {
    DateTime currentDate = DateTime.now();

    chatRepository.openedMessageUpdate(
        {"id": id, "openedAt": currentDate.toIso8601String()});

    DbMessageModel? messageData = messageBox.get(id);

    messageData?.openedAt = currentDate;

    messageBox.put(id, messageData!);
  }

  Future<void> pendingMessageCheck() async {
    List<DbPendingMessageModel> pendingData = pendingMessageBox.values.toList();

    for (var element in pendingData) {
      DbMessageModel? messageData = messageBox.get(element.messageId);

      MessageModel body = MessageModel(
        id: messageData!.id,
        message: messageData.message.isEmpty ? " " : messageData.message,
        from: messageData.from,
        to: messageData.to,
        createdAt: messageData.createdAt,
        messageType: "text",
      );

      var response = await chatRepository.sendMessage(body.toMap());

      if (response.runtimeType.toString() == "Response")
        pendingMessageBox.delete(messageData.id);
    }
  }

  @override
  void onInit() {
    messageTextField.text = "";
    messageTextField.clear();

    super.onInit();
  }

  @override
  void dispose() {
    messageTextField.dispose();
    super.dispose();
  }
}
