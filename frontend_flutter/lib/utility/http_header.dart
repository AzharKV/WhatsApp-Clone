import 'dart:io';

import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';

Future<Map<String, String>> httpHeader(bool auth) async {
  Map<String, String> headers = {HttpHeaders.acceptHeader: "application/json"};

  if (auth) {
    String authToken =
        await SharedPref().readString(SharedPrefKeys().authToken);

    headers.addAll({HttpHeaders.authorizationHeader: "Bearer " + authToken});
  }

  return headers;
}
