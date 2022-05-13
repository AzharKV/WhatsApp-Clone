import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/data/db_models/db_chat_list_model.dart';
import 'package:whatsapp_clone/view/screens/contact_section/contact_list_screen.dart';
import 'package:whatsapp_clone/view/widgets/no_user_image.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static ChatController chatController = Get.put(ChatController());
  static UsersController userController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    userController.getChatList();
    return Scaffold(
      body: Obx(
        () => userController.chatListData.isEmpty
            ? const Center(child: Text('No Chats'))
            : ListView.builder(
                itemCount: userController.chatListData.length,
                padding: const EdgeInsets.only(
                    left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                itemBuilder: (BuildContext context, int index) {
                  DbChatListModel userChat = userController.chatListData[index];

                  userController.updateProfileById(userChat.userId);

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
                                  fontSize: 16.0, fontWeight: FontWeight.w400),
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
                    leading: userNameImage[1].isEmpty
                        ? const NoUserImage()
                        : CircleAvatar(
                            backgroundImage: NetworkImage(userNameImage[1]),
                            radius: 23.0),
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 0.0,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  );
                },
              ),
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
