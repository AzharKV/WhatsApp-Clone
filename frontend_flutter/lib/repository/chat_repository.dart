import 'dart:convert';

import '../models/message/messageModel.dart';
import '../services/api_names.dart';
import '../services/http_helper.dart';

class ChatRepository {
  final HttpHelper _httpHelper = HttpHelper();

  Future<dynamic> sendMessage(dynamic body) async {
    var response = await _httpHelper.post(Api.sendMessage, body);

    if (response.runtimeType.toString() == "Response") {
      MessageModel messageModel =
          MessageModel.fromMap(jsonDecode(response.body));
      return messageModel;
    }
    return response;
  }
}
