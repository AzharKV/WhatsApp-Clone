import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/data/db_models/db_user_model.dart';
import 'package:whatsapp_clone/view/widgets/no_user_image.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  static UsersController userController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select contact"),
            Obx(
              () => userController.usersCount.value != 0
                  ? Text("${userController.usersCount.value} contact",
                      style: const TextStyle(fontSize: 12.0))
                  : const SizedBox(),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          Obx(
            () => userController.contactsLoading.value
                ? Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    height: 24.0,
                    width: 24.0,
                    child: const FittedBox(child: CircularProgressIndicator()))
                : PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          child: const Text("Invite a friend"), onTap: () {}),
                      PopupMenuItem(
                          child: const Text("Contacts"), onTap: () {}),
                      PopupMenuItem(
                          child: const Text("Refresh"),
                          onTap: () => userController.updateContactDb()),
                      PopupMenuItem(child: const Text("Help"), onTap: () {}),
                    ],
                  ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DbUserModel>(DbNames.user).listenable(),
        builder: (BuildContext context, Box<DbUserModel> value, Widget? child) {
          List<DbUserModel> data = value.values
              .where((element) => element.id != userController.userId.value)
              .toList();
          data.sort((a, b) => a.name.compareTo(b.name));

          userController.usersCount.value = data.length;

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.only(top: 8.0),
            itemBuilder: (BuildContext context, int index) {
              DbUserModel userData = data[index];

              // userController.updateProfileById(userData.phone);

              if (index == 0)
                return Column(
                  children: [
                    ListTile(
                      title: const Text("New group"),
                      leading: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: const BoxDecoration(
                            color: MyColor.buttonColor, shape: BoxShape.circle),
                        child: const Icon(Icons.people),
                      ),
                    ),
                    ListTile(
                      title: const Text("New contact"),
                      leading: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: const BoxDecoration(
                            color: MyColor.buttonColor, shape: BoxShape.circle),
                        child: const Icon(Icons.person_add),
                      ),
                      trailing: const Icon(Icons.qr_code),
                    ),
                    ListTile(
                      onTap: () {
                        Get.back();
                        ChatController chatController =
                            Get.put(ChatController());
                        chatController.navigateToChatDetailsScreen(
                            userData.id, userData.name);
                      },
                      title: Text(userData.name),
                      leading: userData.imagePath.isEmpty
                          ? const NoUserImage()
                          : CircleAvatar(
                              backgroundImage: NetworkImage(userData.imagePath),
                              radius: 23.0),
                    ),
                  ],
                );
              else if (index == data.length - 1)
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Get.back();
                        ChatController chatController =
                            Get.put(ChatController());
                        chatController.navigateToChatDetailsScreen(
                            userData.id, userData.name);
                      },
                      title: Text(userData.name),
                      leading: userData.imagePath.isEmpty
                          ? const NoUserImage()
                          : CircleAvatar(
                              backgroundImage: NetworkImage(userData.imagePath),
                              radius: 23.0),
                    ),
                    const ListTile(
                      title: Text("Invite friends"),
                      leading: Icon(Icons.share),
                    ),
                    const ListTile(
                      title: Text("Contact help"),
                      leading: Icon(Icons.help),
                    ),
                  ],
                );
              else
                return ListTile(
                  onTap: () {
                    Get.back();
                    ChatController chatController = Get.put(ChatController());
                    chatController.navigateToChatDetailsScreen(
                        userData.id, userData.name);
                  },
                  title: Text(userData.name),
                  leading: userData.imagePath.isEmpty
                      ? const NoUserImage()
                      : CircleAvatar(
                          backgroundImage: NetworkImage(userData.imagePath),
                          radius: 23.0),
                );
            },
          );
        },
      ),
    );
  }
}
