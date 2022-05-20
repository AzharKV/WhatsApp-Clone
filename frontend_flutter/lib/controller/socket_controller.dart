import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/keys/server_keys.dart';
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/data/db_models/db_chat_list_model.dart';
import 'package:whatsapp_clone/data/db_models/db_message_model.dart';
import 'package:whatsapp_clone/data/model/message/messageModel.dart';
import 'package:whatsapp_clone/data/repository/chat_repository.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';
import 'package:whatsapp_clone/utility/utility.dart';

class SocketController extends GetxController {
  UsersController usersController = Get.put(UsersController());

  Box messageBox = Hive.box<DbMessageModel>(DbNames.message);
  Box chatListBox = Hive.box<DbChatListModel>(DbNames.chatList);

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
      Utility().customDebugPrint("Connected to socket $data");
      UsersController userController = Get.put(UsersController());
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

    socket.onConnecting(
        (data) => Utility().customDebugPrint("Connecting to socket $data"));

    socket.onError(_connectionError);
    socket.onConnectError(_connectionError);
    socket.onReconnectError(_connectionError);
  }

  void _connectionError(dynamic data) {
    Utility().customDebugPrint("socket connection error $data");
    //connectToSocket();
  }

  Future<void> message(dynamic data) async {
    MessageModel messageModel = MessageModel.fromMap(data);

    DateTime currentDateTime = DateTime.now();

    addToMessageDb(messageModel, currentDateTime);

    addToChatList(messageModel, currentDateTime);

    chatRepository.receivedMessageUpdate({
      "id": messageModel.id,
      "receivedAt": currentDateTime.toIso8601String(),
      "fromId": messageModel.from
    });
    usersController.getChatList();
  }

  void addToMessageDb(MessageModel messageModel, DateTime currentDateTime) {
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
  }

  void addToChatList(MessageModel messageModel, DateTime currentDateTime) {
    int messageCount = 1;

    DbChatListModel? chatData = chatListBox.get(messageModel.from);

    if (chatData != null) messageCount = chatData.unreadCount + 1;

    DbChatListModel dbChatListModel = DbChatListModel(
        message: messageModel.message!,
        createdAt: currentDateTime,
        messageId: messageModel.id!,
        userId: messageModel.from!,
        unreadCount: messageCount,
        messageType: "text",
        filePath: "",
        tickCount: 0);

    chatListBox.put(messageModel.from, dbChatListModel);
  }

  void messageReceived(data) {
    String messageId = data["messageId"];
    DateTime receivedDate = DateTime.parse(data["receivedAt"]);

    //update message db
    DbMessageModel messageData = messageBox.get(messageId);
    messageData.receivedAt = receivedDate;
    messageBox.put(messageId, messageData);

    //update chat list count
    DbChatListModel chatData = chatListBox.get(messageData.to);
    chatData.tickCount = 2;
    chatListBox.put(messageData.to, chatData);
    usersController.getChatList();
  }

  void messageOpened(data) {
    String messageId = data["messageId"];
    DateTime openedDate = DateTime.parse(data["openedAt"]);

    //update message db
    DbMessageModel messageData = messageBox.get(messageId);
    messageData.openedAt = openedDate;
    messageBox.put(messageId, messageData);

    //update chat list count
    DbChatListModel chatData = chatListBox.get(messageData.to);
    chatData.tickCount = 3;
    chatListBox.put(messageData.to, chatData);
    usersController.getChatList();
  }
}
