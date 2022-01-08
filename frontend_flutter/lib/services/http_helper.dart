import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/exceptions/fetch_data_exception.dart';
import 'package:whatsapp_clone/utility/utility.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  Future<dynamic> get(String url, {bool auth = true}) async {
    debugPrint("requesting for " + url);
    Map<String, String> header = await Utility.getHeader(auth);

    try {
      var result = await http.get(Uri.parse(url), headers: header);

      return Utility.httpResponse(result, url, "get");
    } on SocketException {
      throw FetchDataException("No Internet");
    } catch (e) {
      debugPrint("http catch get $e");
    }

    return null;
  }
}
