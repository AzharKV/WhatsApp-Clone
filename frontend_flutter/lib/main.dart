import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/socket_controller.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/routes/app_routes.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/services/database_helper.dart';
import 'package:whatsapp_clone/view/theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await DatabaseHelper().initDB();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: MyColor.primaryColor));

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
      initialRoute: initialRoute(),
      getPages: AppRoutes.routes,
      // onInit: () {
      //   SharedPref().saveString(SharedPrefKeys.authToken,
      //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWMyMjMxOGRlZTEwMTc2OGJiNTBlNmUiLCJpYXQiOjE2NDUxMjgxOTd9.WFUmHFEEsnUdAJi2-2MYGXA2aneBPeni0G1F7VC6gY0");
      // },
      // onReady: () => socketController.connectToSocket(),
    );
  }

  String initialRoute() {
    //if saved user home
    // return RoutesNames.home;
    //else termsCondition accept screen
    //return RoutesNames.termsCondition;

    //
    return RoutesNames.termsCondition;
  }
}
