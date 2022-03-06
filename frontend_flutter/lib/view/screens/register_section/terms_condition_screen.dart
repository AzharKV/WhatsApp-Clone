import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/view/screens/register_section/phone_enter_screen.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/common_scaffold.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CommonAppBar(whiteBackground: true),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: FittedBox(
              child: Text(
                "Welcome to Whatsapp",
                style: TextStyle(
                    color: MyColor.primaryColor, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Image.asset(
              "assets/images/initialIcon.png",
              width: Get.width / 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "Read our"),
                  TextSpan(
                      text: " Privacy Policy.",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  const TextSpan(
                      text: " Tap \"Agree and continue\" to accept the"),
                  TextSpan(
                      text: " Terms of Service.",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                ],
                style: const TextStyle(color: Colors.grey, fontSize: 13.0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          sizedBoxH8,
          ElevatedButton(
            onPressed: () => Get.offAll(() => const PhoneEnterScreen()),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => MyColor.buttonColor),
              padding: MaterialStateProperty.resolveWith((states) =>
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 52.0)),
            ),
            child: const Text(
              "AGREE AND CONTINUE",
              style: TextStyle(color: Colors.white),
            ),
          ),
          sizedBoxH32,
        ],
      ),
    );
  }
}
