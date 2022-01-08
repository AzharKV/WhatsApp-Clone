import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/routes/app_routes.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/services/socket_connection.dart';
import 'package:whatsapp_clone/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWM5ZjgxYzA2NTgzMGNjMzAzOWM3ZWYiLCJpYXQiOjE2NDA2MjYyMDR9.lqIa5VYK2ZJmxZP5joHoSP0nDxwJqX_zbN2lbt64rUI");
      // },
      onReady: () => SocketConnection().connectToSocket(),
    );
  }
}
