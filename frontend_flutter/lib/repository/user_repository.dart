import 'dart:convert';

import 'package:whatsapp_clone/const_files/api_names.dart';
import 'package:whatsapp_clone/models/user/user_model.dart';
import 'package:whatsapp_clone/models/user/user_status_model.dart';
import 'package:whatsapp_clone/models/user/users_list_model.dart';
import 'package:whatsapp_clone/services/http_helper.dart';

class UserRepository {
  final HttpHelper _httpHelper = HttpHelper();

  Future<dynamic> getUserDetails() async {
    var response = await _httpHelper.get(Api.myDetails);

    if (response.runtimeType.toString() == "Response") {
      UserModel userModel = UserModel.fromMap(jsonDecode(response.body));
      return userModel;
    }
    return response;
  }

  Future<dynamic> getUsersList() async {
    var response = await _httpHelper.get(Api.usersList);

    if (response.runtimeType.toString() == "Response") {
      UsersListModel usersListModel =
          UsersListModel.fromMap(jsonDecode(response.body));
      return usersListModel;
    }
    return response;
  }

  Future<dynamic> getUserStatus(String id) async {
    var response = await _httpHelper.get(Api.userStatus + id);

    if (response.runtimeType.toString() == "Response") {
      UserStatusModel userStatusModel =
          UserStatusModel.fromMap(jsonDecode(response.body));
      return userStatusModel;
    }
    return response;
  }

  Future<dynamic> updateUserStatus(bool status) async =>
      await _httpHelper.put(Api.userStatus, {"status": "$status"});
}
