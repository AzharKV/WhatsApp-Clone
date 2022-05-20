import 'package:whatsapp_clone/const_files/keys/server_keys.dart';

class Api {
  static const String myDetails = "${ServerKeys.baseurl}myDetails";
  static const String usersList = "${ServerKeys.baseurl}getUsers";
  static const String userStatus = "${ServerKeys.baseurl}userStatus";
  static const String sendMessage = "${ServerKeys.baseurl}sendMessage";
  static const String receivedMessageUpdate =
      "${ServerKeys.baseurl}receivedMessageUpdate";
  static const String openedMessageUpdate =
      "${ServerKeys.baseurl}openedMessageUpdate";
  static const String userDetails = "${ServerKeys.baseurl}user/";
  static const String userDetailsById = "${ServerKeys.baseurl}userById/";
  static const String profileImage = "${ServerKeys.baseurl}profileImage";
  static const String userName = "${ServerKeys.baseurl}userName";
  static const String userRegistration =
      "${ServerKeys.baseurl}userRegistration";
}
