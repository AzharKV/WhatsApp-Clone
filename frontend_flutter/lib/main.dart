import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/controller/socket_controller.dart';
import 'package:whatsapp_clone/databse/databse_helper.dart';
import 'package:whatsapp_clone/routes/app_routes.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/theme/light_theme.dart';

Future<void> main() async {
  await DatabaseHelper().initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static SocketController socketController =
      Get.put(SocketController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'whatsapp_clone',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.downToUp,
      initialRoute: RoutesNames.home,
      getPages: AppRoutes.routes,
      // onInit: () {
      //   SharedPref().saveString(SharedPrefKeys().authToken,
      //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWMyMjMxOGRlZTEwMTc2OGJiNTBlNmUiLCJpYXQiOjE2NDQ2ODc1NzF9.7n9IlZ7gtbDYOUVt_PlAqpyEQGJAmEMyq2AK6BUOs_M");
      // },
      onReady: () => socketController.connectToSocket(),
    );
  }
}
