import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/screens/chat/components/message_list.dart';
import 'package:whatsapp_clone/screens/chat/components/message_send_tile.dart';
import 'package:whatsapp_clone/screens/chat/widgets/chat_user_header.dart';
import 'package:whatsapp_clone/widgets/sizedbox.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, required this.userId, required this.userName})
      : super(key: key);

  final String userId, userName;

  static ChatController chatController = Get.put(ChatController());
  static UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFece5dd),
      appBar: AppBar(
        titleSpacing: 12.0,
        title: Row(
          children: [
            Container(
              height: 35.0,
              width: 35.0,
              decoration: BoxDecoration(
                  color: Colors.grey.shade400, shape: BoxShape.circle),
              child: const Icon(Icons.photo_camera),
            ),
            sizedBoxW8,
            ChatUserHeader(userName: userName, chatController: chatController),
          ],
        ),
        leadingWidth: 25.0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_sharp)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          MessageList(
              userId: userId,
              userController: userController,
              chatController: chatController),
          MessageSendTile(chatController: chatController, userId: userId)
        ],
      ),
    );
  }
}
