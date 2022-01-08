import 'dart:convert';

import 'package:whatsapp_clone/models/user/user_model.dart';
import 'package:whatsapp_clone/services/api_names.dart';
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
}
