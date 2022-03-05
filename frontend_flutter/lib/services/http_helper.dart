import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/exceptions/fetch_data_exception.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';
import 'package:whatsapp_clone/utility/utility.dart';

class HttpHelper {
  Future<dynamic> get(String url, {bool auth = true}) async {
    debugPrint("requesting for " + url);
    Map<String, String> header = await httpHeader(auth);

    try {
      var response = await http.get(Uri.parse(url), headers: header);

      return Utility.httpResponse(response, url, "get");
    } on SocketException {
      throw FetchDataException("No Internet");
    } catch (e) {
      debugPrint("http catch get $e");
    }

    return null;
  }

  Future<dynamic> post(String url, dynamic body, {bool auth = true}) async {
    debugPrint("requesting for " + url + " body $body");

    Map<String, String>? header = await httpHeader(auth);

    try {
      var response =
          await http.post(Uri.parse(url), body: body, headers: header);

      return Utility.httpResponse(response, url, "post");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      debugPrint("http catch post $e");
    }
    return null;
  }

  Future<dynamic> put(String url, dynamic body, {bool auth = true}) async {
    debugPrint("requesting for " + url + " body $body");
    Map<String, String>? header = await httpHeader(auth);

    try {
      var response =
          await http.put(Uri.parse(url), body: body, headers: header);

      return Utility.httpResponse(response, url, "put");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      debugPrint("http catch put $e");
    }

    return null;
  }

  Future<dynamic> delete(String url, {bool auth = true}) async {
    debugPrint("requesting for " + url);

    Map<String, String>? header = await httpHeader(auth);
    try {
      var response = await http.delete(Uri.parse(url), headers: header);
      return Utility.httpResponse(response, url, "delete");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      debugPrint("http catch delete $e");
    }

    return null;
  }

  Future<Map<String, String>> httpHeader(bool auth) async {
    Map<String, String> headers = {
      HttpHeaders.acceptHeader: "application/json"
    };

    if (auth) {
      String authToken =
          await SharedPref().readString(SharedPrefKeys.authToken);

      headers.addAll({HttpHeaders.authorizationHeader: "Bearer " + authToken});
    }

    return headers;
  }
}
