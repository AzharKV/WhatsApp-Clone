import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/routes/routes_names.dart';
import 'package:whatsapp_clone/view/widgets/common_dialog_box.dart';

class ProfileController extends GetxController {
  TextEditingController username = TextEditingController();

  RxString imageUrl =
      "http://thenewcode.com/assets/images/thumbnails/sarah-parmenter.jpeg".obs;

  Future<void> getMyDetails() async {
    // var result = await userRepository.getMyDetails();
    //
    // try {
    //   if (result.runtimeType.toString() == 'UserModel') {
    //     UserModel data = result;
    //     userData.value = data;
    //     userId.value = data.id ?? "";
    //
    //     SharedPreferences preferences = await SharedPreferences.getInstance();
    //
    //     preferences.setString(SharedPrefKeys.userId, userId.value);
    //     preferences.setString(
    //         SharedPrefKeys.userDetails, data.toMap().toString());
    //   } else {
    //     Utility.httpResponseValidation(result);
    //   }
    // } catch (e) {
    //   debugPrint("error getMyDetails $e");
    // }
  }

  void uploadProfileImage() {
    // Future<XFile?> imagePicker =
    //     ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 30);
  }

  void navTOHomeScreen() {
    if (username.text.isEmpty) {
      CommonDialogBoxes().customDialog(
        title: "Please enter your name",
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
      Get.offAllNamed(RoutesNames.home);
    }
  }
}
