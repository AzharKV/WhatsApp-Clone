import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/data/db_models/db_chat_list_model.dart';
import 'package:whatsapp_clone/view/screens/contact_section/contact_list_screen.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static ChatController chatController = Get.put(ChatController());
  static UsersController userController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<DbChatListModel>(DbNames.chatList).listenable(),
        builder:
            (BuildContext context, Box<DbChatListModel> value, Widget? child) {
          value.values
              .toList()
              .sort((a, b) => a.createdAt.compareTo(b.createdAt));

          return value.values.toList().isEmpty
              ? const Center(child: Text('No Chats'))
              : ListView.builder(
                  itemCount: value.values.toList().length,
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                  itemBuilder: (BuildContext context, int index) {
                    DbChatListModel userChat = value.values.toList()[index];

                    String date =
                        chatController.timerConverter(userChat.createdAt);

                    List<String> userNameImage =
                        userController.getUserNameImage(userChat.userId);

                    return ListTile(
                      onTap: () {
                        chatController.navigateToChatDetailsScreen(
                            userChat.userId, userNameImage[0]);
                      },
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                userNameImage[0],
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            sizedBoxW4,
                            Text(
                              date,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: userChat.unreadCount == 0
                                      ? Colors.grey
                                      : MyColor.buttonColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          if (userChat.tickCount != 0)
                            if (userChat.tickCount == 3)
                              const Icon(Icons.done_all,
                                  size: 14.0, color: Colors.blue)
                            else if (userChat.tickCount == 2)
                              const Icon(Icons.done_all, size: 14.0)
                            else
                              const Icon(Icons.check, size: 14.0),
                          if (userChat.tickCount != 0) sizedBoxW4,
                          Expanded(
                            child: Text(
                              userChat.message,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          sizedBoxW4,
                          if (userChat.unreadCount != 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: const BoxDecoration(
                                  color: MyColor.buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                              alignment: Alignment.center,
                              child: Text(
                                userChat.unreadCount.toString(),
                                style: const TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      leading: Container(
                        height: 48.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.person,
                            size: 35.0, color: Colors.white),
                      ),
                      minLeadingWidth: 0.0,
                      minVerticalPadding: 0.0,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                    );
                  },
                );
        },
      ),
      floatingActionButton: InkWell(
        onTap: () => Get.to(() => const ContactListScreen()),
        child: Container(
          height: 52.0,
          width: 52.0,
          decoration: const BoxDecoration(
              color: MyColor.buttonColor, shape: BoxShape.circle),
          child: const Icon(
            Icons.message,
            color: Colors.white,
            size: 22.0,
          ),
        ),
      ),
    );
  }
}
