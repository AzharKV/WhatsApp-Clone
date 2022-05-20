import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/profile_controller.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/common_scaffold.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class InitialProfileScreen extends StatelessWidget {
  const InitialProfileScreen({Key? key}) : super(key: key);

  static ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CommonAppBar(
        title: "Profile info",
        titleColor: MyColor.primaryColor,
        titleSize: 18.0,
        centreTitle: true,
        whiteBackground: true,
      ),
      body: Column(
        children: [
          const Text("Please provide your name and an optional profile photo",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center),
          sizedBoxH16,
          GestureDetector(
            onTap: () => profileController.uploadProfileImage(),
            child: Obx(
              () => Container(
                width: Get.width / 2.5,
                height: Get.width / 2.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  image: profileController.imageUrl.value.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(profileController.imageUrl.value),
                          fit: BoxFit.cover)
                      : null,
                ),
                child: profileController.imageUrl.value.isNotEmpty
                    ? null
                    : const Icon(
                        Icons.camera_alt_rounded,
                        size: 50.0,
                        color: Colors.grey,
                      ),
              ),
            ),
          ),
          sizedBoxH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: profileController.username,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: const InputDecoration(
                        hintText: "Type your name here",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColor.buttonColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: MyColor.buttonColor))),
                  ),
                ),
                const Icon(Icons.emoji_emotions_outlined, color: Colors.grey)
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => profileController.navTOHomeScreen(),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => MyColor.buttonColor),
            ),
            child: const Text("Next"),
          ),
          sizedBoxH16,
        ],
      ),
    );
  }
}
