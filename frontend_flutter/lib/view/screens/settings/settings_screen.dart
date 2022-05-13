import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/view/screens/profile/profile_screen.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/no_user_image.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsersController usersController = Get.put(UsersController());
    usersController.getMyDetails();

    return Scaffold(
      appBar: const CommonAppBar(title: "Settings", leadingWhiteColor: true),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => Row(
                children: [
                  if (usersController.userData.value.image != null &&
                      usersController.userData.value.image!.isEmpty)
                    const NoUserImage(containerSize: 60, iconSize: 35)
                  else
                    CircleAvatar(
                        backgroundImage: NetworkImage(
                            usersController.userData.value.image ?? "no link"),
                        radius: 35),
                  sizedBoxW8,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(usersController.userData.value.name ?? ""),
                      Text(usersController.userData.value.about ?? ""),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text("Account"),
            subtitle: const Text(
              "Privacy, security, change number",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Get.to(() => const ProfileScreen()),
          ),
          const ListTile(
            leading: Icon(Icons.chat),
            title: Text("Chats"),
            subtitle: Text(
              "Theme, wallpapers, chat history",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            subtitle: Text(
              "Message, group & call tones",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.sync),
            title: Text("Storage and data"),
            subtitle: Text(
              "Network usage, auto-download",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text("Help"),
            subtitle: Text(
              "help center, contact us, privacy policy",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.people),
            title: Text("Invite a friend"),
          ),
        ],
      ),
    );
  }
}
