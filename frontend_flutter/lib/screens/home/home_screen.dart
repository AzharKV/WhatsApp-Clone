import 'package:flutter/material.dart';
import 'package:whatsapp_clone/controller/user_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatsapp"),
      ),
      body: Obx(() => Text(_userController.userData.value.name ?? ".....")),
    );
  }
}
