import 'package:whatsapp_clone/models/user/user_model.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserRepository userRepository = UserRepository();

  Rx<UserModel> userData = UserModel().obs;

  Future<void> getMyDetails() async {
    var result = await userRepository.getUserDetails();

    try {
      if (result.runtimeType.toString() == 'UserModel') {
        UserModel data = result;
        userData.value = data;
      } else {
        Utility.httpResponseValidation(result);
      }
    } catch (e) {
      debugPrint("error getMyDetails $e");
    }
  }

  @override
  void onInit() {
    getMyDetails();
    super.onInit();
  }
}
