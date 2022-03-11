import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/data/db_models/db_message_model.dart';
import 'package:whatsapp_clone/view/screens/chat_details/widgets/message_tile/message_tile.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.userId,
    required this.userController,
    required this.chatController,
  }) : super(key: key);

  final String userId;
  final UsersController userController;
  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: Hive.box<DbMessageModel>(DbNames.message).listenable(),
        builder:
            (BuildContext context, Box<DbMessageModel> value, Widget? child) {
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

          List<DbMessageModel> data = [...fromCurrentUser, ...fromThisUser];

          data.sort((a, b) => a.createdAt.compareTo(b.createdAt));

          return data.isEmpty
              ? const Center(child: Text('No messages'))
              : ListView.separated(
                  reverse: true,
                  itemCount: data.length,
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                  itemBuilder: (BuildContext context, int index) {
                    int newIndex = data.length - 1 - index;

                    DbMessageModel message = data[newIndex];

                    if (message.from == userId && message.openedAt == null)
                      chatController.openedMessageUpdate(
                          message.id, message.from);

                    return MessageTile(
                      messageText: message.message,
                      myMessage: message.from == userId ? false : true,
                      send: true,
                      received: message.receivedAt == null ? false : true,
                      opened: message.openedAt == null ? false : true,
                      index: index,
                      dateTime: message.from == userId
                          ? message.receivedAt ?? DateTime.now()
                          : message.createdAt,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 6.0),
                );
        },
      ),
    );
  }
}
