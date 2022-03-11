import 'package:whatsapp_clone/const_files/api_names.dart';
import 'package:whatsapp_clone/services/http_helper.dart';

class ChatRepository {
  final HttpHelper _httpHelper = HttpHelper();

  Future<dynamic> sendMessage(dynamic body) async =>
      await _httpHelper.post(Api.sendMessage, body);

  Future<dynamic> receivedMessageUpdate(dynamic body) async =>
      await _httpHelper.put(Api.receivedMessageUpdate, body);

  Future<dynamic> openedMessageUpdate(dynamic body) async =>
      await _httpHelper.put(Api.openedMessageUpdate, body);
}
