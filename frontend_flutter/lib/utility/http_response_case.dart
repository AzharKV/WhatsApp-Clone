import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//http.Response
dynamic httpResponseCase(http.Response response, String url, String method) {
  var responseBody = jsonDecode(response.body);
  try {
    debugPrint(
        "*Response of url: $url \nmethod: $method code: ${response.statusCode}\nresponse $responseBody*");

    switch (response.statusCode) {
      case 200:
        return response;

      case 404:
        return null;
    }
  } catch (e) {
    debugPrint("Server Error");
  }

  return response;
}
