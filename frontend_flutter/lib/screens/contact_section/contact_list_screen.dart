import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/database/db_models/db_user_model.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Select contact"),
            Text(
              "350 contact",
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DbUserModel>(DbNames.user).listenable(),
        builder: (BuildContext context, Box<DbUserModel> value, Widget? child) {
          List<DbUserModel> data = value.values.toList();

          data.sort((a, b) => a.name.compareTo(b.name));

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.only(top: 8.0),
            itemBuilder: (BuildContext context, int index) {
              DbUserModel userData = data[index];

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
                      leading: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.person,
                            size: 35.0, color: Colors.white),
                      ),
                    ),
                  ],
                );
              else if (index == 4)
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
                      leading: Container(
                        height: 40.0,
                        width: 40.0,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.person,
                            size: 35.0, color: Colors.white),
                      ),
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
                  leading: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300, shape: BoxShape.circle),
                    child: const Icon(Icons.person,
                        size: 35.0, color: Colors.white),
                  ),
                );
            },
          );
        },
      ),
    );
  }
}
