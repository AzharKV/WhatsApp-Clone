import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/no_user_image.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    UsersController usersController = Get.put(UsersController());

    return Scaffold(
      appBar: const CommonAppBar(title: "Profile", leadingWhiteColor: true),
      body: ListView(
        padding: const EdgeInsets.only(top: 16.0),
        children: [
          Center(
            child: Obx(
              () => Stack(
                children: [
                  if (usersController.userData.value.image != null &&
                      usersController.userData.value.image!.isEmpty)
                    NoUserImage(containerSize: width / 2.1, iconSize: width / 4)
                  else
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          usersController.userData.value.image ?? "no link"),
                      radius: width / 3.9,
                    ),
                  Positioned(
                    bottom: 8.0,
                    right: 8.0,
                    child: InkWell(
                      onTap: () => usersController.updateProfileImage(),
                      child: Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: const BoxDecoration(
                            color: MyColor.buttonColor, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            minLeadingWidth: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name",
                        style: TextStyle(color: Colors.grey, fontSize: 13.0)),
                    Obx(() => Text(usersController.userData.value.name ?? "")),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: MyColor.buttonColor))
              ],
            ),
            subtitle: const Text(
                "This is not your username or pin. This name will be vissible to your Whatsapp contancts.",
                style: TextStyle(color: Colors.grey, fontSize: 13.0)),
          ),
          sizedBoxH8,
          ListTile(
            leading: const Icon(Icons.error),
            minLeadingWidth: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("About",
                        style: TextStyle(color: Colors.grey, fontSize: 13.0)),
                    Obx(() => Text(usersController.userData.value.about ?? "")),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: MyColor.buttonColor))
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.call),
            minLeadingWidth: 0.0,
            title: const Text("Phone", style: TextStyle(color: Colors.grey)),
            subtitle: Obx(() =>
                Text(usersController.userData.value.phoneWithDialCode ?? "")),
          )
        ],
      ),
    );
  }
}
