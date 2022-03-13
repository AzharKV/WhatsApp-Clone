import 'package:get/get.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/view/screens/home/home_screen.dart';
import 'package:whatsapp_clone/view/screens/profile/initial_profile_screen.dart';
import 'package:whatsapp_clone/view/screens/register_section/phone_enter_screen.dart';
import 'package:whatsapp_clone/view/screens/register_section/terms_condition_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(name: RoutesNames.indexPage, page: () => const IndexPage()),
    GetPage(name: RoutesNames.home, page: () => const HomeScreen()),
    GetPage(
        name: RoutesNames.termsCondition,
        page: () => const TermsConditionScreen()),
    GetPage(
        name: RoutesNames.enterNumberScreen,
        page: () => const PhoneEnterScreen()),
    GetPage(
        name: RoutesNames.initialProfileScreen,
        page: () => const InitialProfileScreen()),
  ];
}
