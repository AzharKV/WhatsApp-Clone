import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/register_controller.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/common_scaffold.dart';
import 'package:whatsapp_clone/view/widgets/resend_tile.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class OTPEnterScreen extends StatelessWidget {
  const OTPEnterScreen({
    Key? key,
    required this.phoneNumber,
    required this.dialCode,
  }) : super(key: key);

  final String phoneNumber;
  final String dialCode;

  static RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(
        title: "Verify your number",
        titleColor: MyColor.primaryColor,
        titleSize: 18.0,
        centreTitle: true,
        whiteBackground: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: 1.0,
            icon: const Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text:
                        "We have sent an SMS with a code to +$dialCode $phoneNumber."),
                TextSpan(
                    text: " Wrong number?",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
              ],
              style: const TextStyle(color: Colors.black, fontSize: 13.0),
            ),
            textAlign: TextAlign.center,
          ),
          sizedBoxH8,
          SizedBox(
            width: Get.width / 1.75,
            child: TextField(
              controller: registerController.smsCode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlignVertical: TextAlignVertical.bottom,
              cursorColor: MyColor.buttonColor,
              onChanged: (String value) =>
                  registerController.otpValue.value = value,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Enter OTP here",
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: MyColor.buttonColor, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: MyColor.buttonColor, width: 2.0)),
              ),
            ),
          ),
          sizedBoxH16,
          const Text("Enter 6-digit code",
              style: TextStyle(color: Colors.grey)),
          sizedBoxH16,
          const ResendTIle(
              leadingIcon: Icons.message,
              title: "Resend SMS",
              trailing: "1:00"),
          const Divider(),
          const ResendTIle(
              leadingIcon: Icons.call, title: "Call me", trailing: "1:00"),
          const Spacer(),
          Obx(
            () => registerController.otpValue.isNotEmpty
                ? ElevatedButton(
                    onPressed: () => registerController.verifyOTP(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => MyColor.buttonColor),
                    ),
                    child: const Text("Verify"),
                  )
                : const SizedBox(),
          ),
          sizedBoxH16,
        ],
      ),
    );
  }
}
