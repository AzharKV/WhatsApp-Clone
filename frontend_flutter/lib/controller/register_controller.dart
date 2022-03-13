import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/country_list.dart';
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/data/model/county_model.dart';
import 'package:whatsapp_clone/data/model/user_login_registration_model.dart';
import 'package:whatsapp_clone/data/repository/user_repository.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';
import 'package:whatsapp_clone/utility/utility.dart';
import 'package:whatsapp_clone/view/screens/register_section/otp_enter_screen.dart';
import 'package:whatsapp_clone/view/widgets/common_dialog_box.dart';

class RegisterController extends GetxController {
  static CountryModel countryModel = CountryModel.fromMap(countryListData);

  FirebaseAuth auth = FirebaseAuth.instance;

  CommonDialogBoxes commonDialogBoxes = CommonDialogBoxes();

  TextEditingController dialCode = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController smsCode = TextEditingController();

  RxString otpValue = "".obs;

  RxBool isInvalidCode = false.obs;

  Rx<Datum> selectedCountry = Datum(
          flag: countryModel.data[0].flag,
          name: countryModel.data[0].name,
          code: countryModel.data[0].code,
          dialCode: countryModel.data[0].dialCode)
      .obs;

  late String codeVerificationId;

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
      commonDialogBoxes.customDialog(
          title: "Invalid country code", getBackOK: true);
    } else if (phoneNumber.text.isEmpty) {
      commonDialogBoxes.customDialog(
          title: "Please enter your phone number", getBackOK: true);
    } else {
      commonDialogBoxes.loadingDialog();

      await phoneAuth();
    }
  }

  Future<void> phoneAuth() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+${dialCode.text}${phoneNumber.text}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async =>
          await auth.signInWithCredential(credential),
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        codeVerificationId = verificationId;
        Get.to(() => OTPEnterScreen(
            phoneNumber: phoneNumber.text, dialCode: dialCode.text));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTP() async {
    commonDialogBoxes.loadingDialog();

    if (codeVerificationId.isEmpty) {
      commonDialogBoxes.customDialog(
          title: "Something wrong..\nTry again", getBackOK: true);
    } else if (smsCode.text.length != 6) {
      commonDialogBoxes.customDialog(
          title: "Please enter 6 digit code", getBackOK: true);
    } else {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: codeVerificationId, smsCode: smsCode.text);

        await auth.signInWithCredential(credential);

        await loginTOServer();
      } catch (e) {
        Utility().customDebugPrint("verification failed $e");
      }
    }
  }

  Future<void> loginTOServer() async {
    UserRepository userRepository = UserRepository();

    SharedPref sharedPref = SharedPref();

    dynamic result = await userRepository.userLoginRegistration(
        phoneNumber.text, dialCode.text);

    if (result.runtimeType.toString() == "UserLoginRegistrationModel") {
      UserLoginRegistrationModel userData = result;

      await sharedPref.saveString(
          SharedPrefKeys.authToken, userData.token ?? "");

      Get.offAllNamed(RoutesNames.initialProfileScreen);
    }
  }
}
