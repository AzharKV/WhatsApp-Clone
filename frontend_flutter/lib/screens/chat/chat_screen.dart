import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/models/message/messageModel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, required this.userId, required this.userName})
      : super(key: key);

  final String userId, userName;

  static ChatController chatController = Get.put(ChatController());
  static UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName),
            Obx(() => chatController.userStatus.value
                ? Text("Online", style: Theme.of(context).textTheme.subtitle2)
                : const SizedBox()),
          ],
        ),
        leadingWidth: 25.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                itemCount: chatController.message.length,
                itemBuilder: (BuildContext context, int index) {
                  MessageModel message = chatController.message[index];

                  return ListTile(
                    title: Text(
                      message.message.toString(),
                      textAlign: message.from == userController.userId.value
                          ? TextAlign.end
                          : TextAlign.start,
                    ),
                    subtitle: Text(
                      message.from.toString(),
                      textAlign: message.from == userController.userId.value
                          ? TextAlign.end
                          : TextAlign.start,
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 1)
                      ]),
                  child: TextField(
                    controller: chatController.messageTextField,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    chatController.sendMessage(userId);
                  },
                  icon: const Icon(Icons.send)),
            ],
          )
        ],
      ),
    );
  }
}
