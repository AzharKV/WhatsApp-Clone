import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/socket_controller.dart';
import 'package:whatsapp_clone/controller/users_controller.dart';
import 'package:whatsapp_clone/view/screens/call_section/call_list_screen.dart';
import 'package:whatsapp_clone/view/screens/camera_section/camera_screen.dart';
import 'package:whatsapp_clone/view/screens/chat_list/chat_list_screen.dart';
import 'package:whatsapp_clone/view/screens/settings/settings_screen.dart';
import 'package:whatsapp_clone/view/screens/status_section/status_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static SocketController socketController =
      Get.put(SocketController(), permanent: true);
  UsersController userController = Get.put(UsersController());

  double customWidth = (Get.width - 20) / 5;
  double customHeight = 40;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    socketController.connectToSocket();

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
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WhatsApp'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(child: const Text("New group"), onTap: () {}),
                PopupMenuItem(child: const Text("New broadcast"), onTap: () {}),
                PopupMenuItem(
                    child: const Text("Linked devices"), onTap: () {}),
                PopupMenuItem(
                    child: const Text("Starred messages"), onTap: () {}),
                PopupMenuItem(child: const Text("Payments"), onTap: () {}),
                PopupMenuItem(
                    child: const Text("Settings"),
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 1));
                      Get.to(() => const SettingsScreen());
                    }),
              ],
            ),
          ],
          toolbarHeight: 48.0,
          elevation: 0.0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: MyColor.primaryColor),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Container(
                width: 20,
                height: customHeight,
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.camera_alt),
              ),
              Container(
                  width: customWidth,
                  height: customHeight,
                  alignment: Alignment.center,
                  child: const Text("CHATS")),
              Container(
                  width: customWidth,
                  height: customHeight,
                  alignment: Alignment.center,
                  child: const Text("STATUS")),
              Container(
                  width: customWidth,
                  height: customHeight,
                  alignment: Alignment.center,
                  child: const Text("CALL"))
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CameraScreen(),
            ChatListScreen(),
            StatusListScreen(),
            CallListScreen()
          ],
        ),
      ),
    );
  }
}
