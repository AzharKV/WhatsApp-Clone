import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/country_list.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/model/county_model.dart';
import 'package:whatsapp_clone/view/screens/register_section/otp_enter_screen.dart';
import 'package:whatsapp_clone/view/widgets/common_dialog_box.dart';

class RegisterController extends GetxController {
  static CountryModel countryModel = CountryModel.fromMap(countryListData);

  TextEditingController dialCode = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  RxString otpValue = "".obs;

  RxBool isInvalidCode = false.obs;

  Rx<Datum> selectedCountry = Datum(
          flag: countryModel.data[0].flag,
          name: countryModel.data[0].name,
          code: countryModel.data[0].code,
          dialCode: countryModel.data[0].dialCode)
      .obs;

  @override
  void onInit() {
    dialCode.text = selectedCountry.value.dialCode.split("+")[1];
    super.onInit();
  }

  void changeCountry(Datum country) {
    selectedCountry.value = country;
    dialCode.text = country.dialCode.split("+")[1];
    Get.back();
  }

  void onDialCodeChange(String value) {
    CountryModel tempCountryData = countryModel;
    isInvalidCode.value = false;
    Datum? data = tempCountryData.data
        .firstWhereOrNull((element) => element.dialCode.split("+")[1] == value);

    if (data == null)
      isInvalidCode.value = true;
    else
      selectedCountry.value = data;
  }

  Future<void> navToOtpScreen() async {
    if (isInvalidCode.value) {
      CommonDialogBoxes().customDialog(
        title: "Invalid country code",
        action: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              "OK",
              style: TextStyle(color: MyColor.buttonColor),
            ),
          ),
        ],
      );
    } else if (phoneNumber.text.isEmpty) {
      CommonDialogBoxes().customDialog(
        title: "Please enter your phone number",
        action: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              "OK",
              style: TextStyle(color: MyColor.buttonColor),
            ),
          ),
        ],
      );
    } else {
      CommonDialogBoxes().loadingDialog();

      await Future.delayed(const Duration(seconds: 2));

      Get.to(() => OTPEnterScreen(
          phoneNumber: phoneNumber.text, dialCode: dialCode.text));
    }
  }

  void verifyOTP() {
    CommonDialogBoxes().loadingDialog();
  }
}
