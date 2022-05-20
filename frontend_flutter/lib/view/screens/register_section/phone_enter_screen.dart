import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/register_controller.dart';
import 'package:whatsapp_clone/view/screens/register_section/country_list_screen.dart';
import 'package:whatsapp_clone/view/widgets/common_appbar.dart';
import 'package:whatsapp_clone/view/widgets/common_scaffold.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class PhoneEnterScreen extends StatelessWidget {
  const PhoneEnterScreen({Key? key}) : super(key: key);

  static RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(
        title: "Enter your phone number",
        titleColor: MyColor.primaryColor,
        titleSize: 18.0,
        centreTitle: true,
        whiteBackground: true,
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
                const TextSpan(
                    text: "WhatsApp will need to verify your phone number."),
                TextSpan(
                    text: " What's my number?",
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
            child: Column(
              children: [
                InkWell(
                  onTap: () => Get.to(() => const CountryListScreen()),
                  child: Row(
                    children: [
                      const Spacer(),
                      Obx(() => Text(registerController.isInvalidCode.value
                          ? "Invalid country code"
                          : registerController.selectedCountry.value.name)),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_sharp,
                          color: MyColor.buttonColor)
                    ],
                  ),
                ),
                const Divider(
                    color: MyColor.buttonColor, height: 5.0, thickness: 1.5),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '+',
                                style: TextStyle(color: Colors.black),
                              ),
                              sizedBoxW8,
                              Expanded(
                                child: TextField(
                                  controller: registerController.dialCode,
                                  onChanged:
                                      registerController.onDialCodeChange,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: false, signed: false),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                              color: MyColor.buttonColor,
                              height: 10.0,
                              thickness: 1.5),
                        ],
                      ),
                    ),
                    sizedBoxW8,
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: registerController.phoneNumber,
                        keyboardType: TextInputType.phone,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: "phone number",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColor.buttonColor, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColor.buttonColor, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sizedBoxH8,
          const Text("Carrier charges may apply",
              style: TextStyle(color: Colors.grey)),
          const Spacer(),
          ElevatedButton(
            onPressed: () => registerController.navToOtpScreen(),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => MyColor.buttonColor),
            ),
            child: const Text("Next"),
          ),
          sizedBoxH16,
        ],
      ),
    );
  }
}
