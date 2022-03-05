import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/database/db_models/db_user_model.dart';
import 'package:whatsapp_clone/models/user/user_model.dart';
import 'package:whatsapp_clone/models/user/users_list_model.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/utility/utility.dart';

class UserController extends GetxController {
  UserRepository userRepository = UserRepository();

  Box<DbUserModel> userBox = Hive.box<DbUserModel>(DbNames.user);

  Rx<UserModel> userData = UserModel().obs;
  Rx<UsersListModel> usersListData = UsersListModel().obs;
  RxString userId = "".obs;

  RxInt usersCount = 0.obs;

  RxBool contactsLoading = false.obs;

  Future<void> getMyDetails() async {
    var result = await userRepository.getMyDetails();

    try {
      if (result.runtimeType.toString() == 'UserModel') {
        UserModel data = result;
        userData.value = data;
        userId.value = data.id ?? "";

        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.setString(SharedPrefKeys.userId, userId.value);
        preferences.setString(
            SharedPrefKeys.userDetails, data.toMap().toString());
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

  void updateUserStatus(bool status) {
    userRepository.updateUserStatus(status);
  }

  List<String> getUserNameImage(String userId) {
    DbUserModel? userData = userBox.get(userId);

    if (userData != null)
      return [
        userData.name.isEmpty ? userData.phone.toString() : userData.name,
        userData.imagePath
      ];
    else
      return ["", ""];
  }

  Future<void> updateContactDb() async {
    contactsLoading.value = true;

    List<Contact> contactList = await getDeviceContact();

    for (var element in contactList) {
      if (element.phones != null)
        for (var phoneElement in element.phones!) {
          if (phoneElement.value != null) {
            String phoneNumber = phoneElement.value!
                .replaceAll(" ", "")
                .replaceAll("(", "")
                .replaceAll(")", "")
                .replaceAll("-", "");

            if (phoneNumber.length > 5)
              await checkUser(phoneNumber, element.displayName ?? phoneNumber);
          }
        }
    }

    contactsLoading.value = false;
  }

  Future<void> checkUser(String phoneNumber, String name) async {
    var result = await userRepository.getUserDetails(phoneNumber);

    if (result.runtimeType.toString() == "UserModel") {
      UserModel userData = result;

      DbUserModel dbUserModel = DbUserModel(
        name: name,
        id: userData.id ?? "",
        imagePath: userData.imageUrl ?? "",
        phone: userData.phone ?? "",
        about: userData.about ?? "",
      );

      userBox.put(userData.id!, dbUserModel);
    }
  }

  Future<List<Contact>> getDeviceContact() async {
    bool permissionHave = await Permission.contacts.isGranted;

    if (permissionHave) {
      return await ContactsService.getContacts();
    } else {
      await Permission.contacts.request();
      return await ContactsService.getContacts();
    }
  }

  @override
  void onInit() {
    updateUserStatus(true);
    //usersList();
    getMyDetails();
    super.onInit();
  }
}
