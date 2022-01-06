import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/socket_connection.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WhatsappClone',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.downToUp,
      initialRoute: '/',
      // onInit: () {
      //   SharedPref().saveString(SharedPrefKeys().authToken,
      //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWM5ZjgxYzA2NTgzMGNjMzAzOWM3ZWYiLCJpYXQiOjE2NDA2MjYyMDR9.lqIa5VYK2ZJmxZP5joHoSP0nDxwJqX_zbN2lbt64rUI");
      // },
      onReady: () => SocketConnection().connectToSocket(),
      home: Scaffold(),
    );
  }
}
