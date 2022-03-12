import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/const_files/keys/shared_pref_keys.dart';
import 'package:whatsapp_clone/data/exceptions/fetch_data_exception.dart';
import 'package:whatsapp_clone/services/shared_pref.dart';
import 'package:whatsapp_clone/utility/utility.dart';

class HttpHelper {
  Future<dynamic> get(String url, {bool auth = true}) async {
    Map<String, String> header = await _httpHeader(auth);

    Utility().customDebugPrint("requesting for get $url header $header");

    try {
      var response = await http.get(Uri.parse(url), headers: header);

      Utility().customDebugPrint(
          "url: $url \nheader: ${header.toString()} \nstatusCode: ${response.statusCode} \nresponse ${response.body} ");

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet");
    } catch (e) {
      Utility().customDebugPrint("http catch get $e");
    }

    return null;
  }

  Future<dynamic> post(String url, dynamic body, {bool auth = true}) async {
    Map<String, String>? header = await _httpHeader(auth);

    Utility().customDebugPrint(
        "requesting for post $url \nheader $header \nbody $body");

    try {
      var response =
          await http.post(Uri.parse(url), body: body, headers: header);

      Utility().customDebugPrint(
          "post url: $url \nheader: $header \nbody: $body \nstatusCode: ${response.statusCode} \nresponse ${response.body} ");

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      Utility().customDebugPrint("http catch post $e");
    }
    return null;
  }

  Future<dynamic> put(String url, dynamic body, {bool auth = true}) async {
    Map<String, String>? header = await _httpHeader(auth);

    Utility().customDebugPrint(
        "requesting for put $url \nheader $header \nbody $body");

    try {
      var response =
          await http.put(Uri.parse(url), body: body, headers: header);

      Utility().customDebugPrint(
          "put url: $url \nheader: $header \nbody: $body \nstatusCode: ${response.statusCode} \nresponse ${response.body} ");

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      Utility().customDebugPrint("http catch put $e");
    }

    return null;
  }

  Future<dynamic> delete(String url, {bool auth = true}) async {
    Map<String, String>? header = await _httpHeader(auth);

    Utility().customDebugPrint("requesting for delete $url header $header");

    try {
      var response = await http.delete(Uri.parse(url), headers: header);

      Utility().customDebugPrint(
          "delete url: $url \nheader: $header  \nstatusCode: ${response.statusCode} \nresponse ${response.body} ");

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      Utility().customDebugPrint("http catch delete $e");
    }

    return null;
  }

  Future<dynamic> multipart(String fieldName, String path, String url,
      {bool auth = true}) async {
    Map<String, String>? hd = await _httpHeader(auth);

    Utility().customDebugPrint("requesting for multipart $url \nheader $hd");

    late dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(hd);
      request.files.add(http.MultipartFile.fromBytes(
        fieldName,
        File(path).readAsBytesSync(),
        filename: path.split("/").last,
      ));
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      Utility().customDebugPrint(
          "multiple url: $url \nheader: ${hd.toString()} \nstatusCode: ${response.statusCode} \nresponse ${response.body} ");

      responseJson = _returnResponse(response);
    } on SocketException {
      Utility().customDebugPrint('No net');
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<Map<String, String>> _httpHeader(bool auth) async {
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

  dynamic _returnResponse(http.Response response) async {
    try {
      switch (response.statusCode) {
        case 200:
          return response;

        case 404:
          return null;
      }
    } catch (e) {
      Utility().customDebugPrint("Server Error");
    }
  }
}
