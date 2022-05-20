import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/data/db_models/db_chat_list_model.dart';
import 'package:whatsapp_clone/data/db_models/db_user_model.dart';
import 'package:whatsapp_clone/data/model/user/user_model.dart';
import 'package:whatsapp_clone/data/model/user/users_list_model.dart';
import 'package:whatsapp_clone/data/repository/user_repository.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';
import 'package:whatsapp_clone/utility/utility.dart';

class UserData {
  String id, imagePath;

  UserData(this.id, this.imagePath);
}

class UsersController extends GetxController {
  UserRepository userRepository = UserRepository();
  SharedPref sharedPref = SharedPref();

  Box<DbUserModel> userBox = Hive.box<DbUserModel>(DbNames.user);
  Box<DbChatListModel> chatList = Hive.box<DbChatListModel>(DbNames.chatList);

  Rx<UserModel> userData = UserModel().obs;
  Rx<UsersListModel> usersListData = UsersListModel().obs;
  RxString userId = "".obs;

  RxInt usersCount = 0.obs;

  RxBool contactsLoading = false.obs;

  RxList<DbChatListModel> chatListData = <DbChatListModel>[].obs;

  void getChatList() {
    chatListData.clear();
    chatList.toMap().forEach((key, value) => chatListData.add(value));
    chatListData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> getMyDetails() async {
    var result = await userRepository.getMyDetails();

    try {
      if (result.runtimeType.toString() == 'UserModel') {
        UserModel data = result;
        userData.value = data;
        userId.value = data.id ?? "";

        sharedPref.saveString(SharedPrefKeys.userId, userId.value);
        sharedPref.saveString(
            SharedPrefKeys.userDetails, data.toJson().toString());
      } else {
        Utility.httpResponseValidation(result);
      }
    } catch (e) {
      Utility().customDebugPrint("error getMyDetails $e");
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
        imagePath: userData.image ?? "",
        phone: phoneNumber,
        about: userData.about ?? "",
      );

      await userBox.put(userData.id!, dbUserModel);
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

  Future<void> updateProfileImage() async {
    XFile? imagePicker = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    if (imagePicker != null) {
      dynamic result =
          await userRepository.profileImageUpload(imagePicker.path);

      if (result.runtimeType.toString() == "Response") getMyDetails();
    }
  }

  Future<void> updateProfileByPhoneNumber(String phoneNumber) async {
    var result = await userRepository.getUserDetails(phoneNumber);

    if (result.runtimeType.toString() == "UserModel") {
      UserModel data = result;
      DbUserModel? userData = userBox.get(data.id);

      userData!.imagePath == data.image;

      userBox.put(data.id, userData);
    }
  }

  Future<void> updateProfileById(String userId) async {
    var result = await userRepository.getUserDetailsById(userId);

    if (result.runtimeType.toString() == "UserModel") {
      UserModel data = result;

      String imagePath = userBox.get(userId)?.imagePath ?? "";

      if (imagePath != data.image)
        chatListData.singleWhere((element) => element.userId == userId);

      DbUserModel dbUserModel = DbUserModel(
          id: data.id ?? "",
          name: data.name ?? "",
          about: data.about ?? "",
          imagePath: data.image ?? "",
          phone: data.phoneWithDialCode ?? "");

      userBox.put(userId, dbUserModel);
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
