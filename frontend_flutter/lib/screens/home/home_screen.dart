import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:whatsapp_clone/models/user/user_model.dart';
import 'package:whatsapp_clone/screens/chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      userController.updateUserStatus(true);
    else
      userController.updateUserStatus(false);

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatsapp"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width,
            margin: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child:
                Obx(() => Text(userController.userData.value.name ?? ".....")),
          ),
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount:
                    userController.usersListData.value.users?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  UserModel? userModel =
                      userController.usersListData.value.users?[index];

                  return ListTile(
                    title: Text(userModel?.name ?? ""),
                    subtitle: Text(userModel?.id ?? ""),
                    onTap: () {
                      ChatController chatController = Get.put(ChatController());

                      chatController.checkUserStatus(userModel!.id!);

                      chatController.userStatus.value =
                          userModel.status ?? false;

                      Get.to(() => ChatScreen(
                            userId: userModel.id ?? "",
                            userName: userModel.name ?? "",
                          ));
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
