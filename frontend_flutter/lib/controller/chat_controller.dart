import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/controller/socket_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/data/db_models/db_chat_list_model.dart';
import 'package:whatsapp_clone/data/db_models/db_message_model.dart';
import 'package:whatsapp_clone/data/db_models/db_pending_message_model.dart';
import 'package:whatsapp_clone/data/model/message/messageModel.dart';
import 'package:whatsapp_clone/data/repository/chat_repository.dart';
import 'package:whatsapp_clone/data/repository/user_repository.dart';
import 'package:whatsapp_clone/utility/utility.dart';
import 'package:whatsapp_clone/view/screens/chat_details/chat_details_screen.dart';

class ChatController extends GetxController {
  SocketController socketController = Get.put(SocketController());
  UsersController userController = Get.put(UsersController());

  UserRepository userRepository = UserRepository();
  ChatRepository chatRepository = ChatRepository();

  Box<DbMessageModel> messageBox = Hive.box<DbMessageModel>(DbNames.message);
  Box<DbPendingMessageModel> pendingMessageBox =
      Hive.box<DbPendingMessageModel>(DbNames.pendingMessage);
  Box chatListBox = Hive.box<DbChatListModel>(DbNames.chatList);

  RxBool userStatus = false.obs;

  TextEditingController messageTextField = TextEditingController();

  RxString textControllerValue = "".obs;

  void navigateToChatDetailsScreen(String id, String name) {
    setUnreadMessageToZero(id);
    checkUserStatus(id);

    messageTextField.text = "";
    messageTextField.clear();

    Get.to(() => ChatScreen(userId: id, userName: name));
  }

  void setUnreadMessageToZero(String userId) {
    DbChatListModel? chatData = chatListBox.get(userId);

    if (chatData != null) {
      chatData.unreadCount = 0;
      chatListBox.put(userId, chatData);
    }

    userController.getChatList();
  }

  Future<void> checkUserStatus(String id) async {
    var result = await userRepository.getUserStatus(id);

    try {
      if (result.runtimeType.toString() == 'Response') {
        var data = jsonDecode(result.body);
        userStatus.value = data["status"] ?? false;
      } else
        Utility.httpResponseValidation(result);
    } catch (e) {
      Utility().customDebugPrint("error usersList $e");
    }

    try {
      String eventString = '/user_status$id';

      socketController.socket
          .on(eventString, (data) => userStatus.value = data ?? false);
    } catch (e) {
      Utility().customDebugPrint("status socket error $e");
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

    addToMessageDb(messageId, messageText, userId, currentDate);

    addToPendingDb(messageId);

    addToChatListDb(messageId, messageText, userId, currentDate);

    addToServer(messageId, messageText, userId, currentDate);
  }

  void addToMessageDb(
    String messageId,
    String messageText,
    String userId,
    DateTime currentDate,
  ) {
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
    messageBox.put(messageId, data);
  }

  void addToPendingDb(String messageId) {
    DbPendingMessageModel pendingMessageModel =
        DbPendingMessageModel(messageId);

    pendingMessageBox.put(messageId, pendingMessageModel);
  }

  void addToChatListDb(
    String messageId,
    String messageText,
    String userId,
    DateTime currentDate,
  ) {
    DbChatListModel dbChatListModel = DbChatListModel(
        message: messageText,
        createdAt: currentDate,
        messageId: messageId,
        userId: userId,
        unreadCount: 0,
        messageType: "text",
        filePath: "",
        tickCount: 1);

    chatListBox.put(userId, dbChatListModel);
  }

  Future<void> addToServer(
    String messageId,
    String messageText,
    String userId,
    DateTime currentDate,
  ) async {
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

  void openedMessageUpdate(String id, String fromId) {
    DateTime currentDate = DateTime.now();

    chatRepository.openedMessageUpdate({
      "id": id,
      "openedAt": currentDate.toIso8601String(),
      "fromId": fromId
    });

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

  String timerConverter(DateTime date) {
    int currentDay = DateTime.now().day;
    int previousDay = DateTime.now().subtract(const Duration(days: 1)).day;

    int customDay = date.day;
    int customPreviousDay = date.subtract(const Duration(days: 1)).day;

    if (customDay == currentDay)
      return DateFormat("hh:mm a").format(date);
    else if (previousDay == customPreviousDay)
      return "Yesterday";
    else
      return DateFormat("dd/MM/yy").format(date);
  }
}
