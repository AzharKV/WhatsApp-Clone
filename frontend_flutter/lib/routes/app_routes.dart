import 'package:frontend_flutter/routes/routes_names.dart';
import 'package:frontend_flutter/screens/home/home_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(name: RoutesNames.home, page: () => const HomeScreen()),
  ];
}
