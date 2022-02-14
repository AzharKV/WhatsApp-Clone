import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/databse/db_models/db_message_model.dart';

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
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<DbMessageModel>(DbNames.message).listenable(),
              builder: (BuildContext context, Box<DbMessageModel> value,
                  Widget? child) {
                List<DbMessageModel> fromCurrentUser = value.values
                    .where((c) =>
                        c.to.contains(userId) &&
                        c.from.contains(userController.userId))
                    .toList();

                List<DbMessageModel> fromThisUser = value.values
                    .where((c) =>
                        c.to.contains(userController.userId) &&
                        c.from.contains(userId))
                    .toList();

                List<DbMessageModel> data = [
                  ...fromCurrentUser,
                  ...fromThisUser
                ];

                data.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                return data.isEmpty
                    ? const Center(child: Text('No messages'))
                    : ListView.builder(
                        reverse: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          int newIndex = data.length - 1 - index;

                          DbMessageModel message = data[newIndex];

                          if (message.from == userId &&
                              message.openedAt == null)
                            chatController.openedMessageUpdate(message.id);

                          return ListTile(
                            title: Text(
                              message.message.toString(),
                              textAlign:
                                  message.from == userController.userId.value
                                      ? TextAlign.end
                                      : TextAlign.start,
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  message.from == userController.userId.value
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text("c " + message.createdAt.toString()),
                                Text("r " + message.receivedAt.toString()),
                                Text("o " + message.openedAt.toString()),
                              ],
                            ),
                          );
                        },
                      );
              },
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
