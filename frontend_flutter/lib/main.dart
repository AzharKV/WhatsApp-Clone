import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/routes/app_routes.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/services/database_helper.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';
import 'package:whatsapp_clone/view/screens/home/home_screen.dart';
import 'package:whatsapp_clone/view/screens/register_section/terms_condition_screen.dart';
import 'package:whatsapp_clone/view/theme/light_theme.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/common_scaffold.dart';

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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WhatsAppClone',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.downToUp,
      initialRoute: RoutesNames.indexPage,
      getPages: AppRoutes.routes,
      // onInit: () {
      //   SharedPref().saveString(SharedPrefKeys.authToken,
      //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjJkY2I3MzViZDcyODUyZThjM2M4N2YiLCJpYXQiOjE2NDcxNzIwNjF9.vC6VwZmVyD5QMcTDR9BivsxPb3WqG4jr_3PJfm5ia34");
      // },
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Widget? mainWidget;

  @override
  void initState() {
    initialCheckUp();
    super.initState();
  }

  Future<void> initialCheckUp() async {
    String authToken = await SharedPref().readString(SharedPrefKeys.authToken);

    if (authToken.isEmpty)
      mainWidget = const TermsConditionScreen();
    else
      mainWidget = const HomeScreen();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget ??
        const CommonScaffold(
            appBar: CommonAppBar(whiteBackground: true), body: SizedBox());
  }
}
