import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/models/user/user_model.dart';
import 'package:whatsapp_clone/models/user/users_list_model.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/utility/utility.dart';

class UserController extends GetxController {
  UserRepository userRepository = UserRepository();

  Rx<UserModel> userData = UserModel().obs;
  Rx<UsersListModel> usersListData = UsersListModel().obs;
  RxString userId = "".obs;

  Future<void> getMyDetails() async {
    var result = await userRepository.getUserDetails();

    try {
      if (result.runtimeType.toString() == 'UserModel') {
        UserModel data = result;
        userData.value = data;
        userId.value = data.id ?? "";
      } else {
        Utility.httpResponseValidation(result);
      }
    } catch (e) {
      debugPrint("error getMyDetails $e");
    }
  }

  Future<void> usersList() async {
    var result = await userRepository.getUsersList();

    try {
      if (result.runtimeType.toString() == 'UsersListModel') {
        UsersListModel data = result;
        usersListData.value = data;
      } else {
        Utility.httpResponseValidation(result);
      }
    } catch (e) {
      debugPrint("error usersList $e");
    }
  }

  @override
  void onInit() {
    usersList();
    getMyDetails();
    super.onInit();
  }
}
