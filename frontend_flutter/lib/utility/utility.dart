import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/utility/http_header.dart';
import 'package:whatsapp_clone/utility/http_response_case.dart';

class Utility {
  //http response filtering with status code
  static dynamic httpResponse(
          http.Response response, String url, String method) =>
      httpResponseCase(response, url, method);

  //http header
  static Future<Map<String, String>> getHeader(bool auth) => httpHeader(auth);

  // http response validation

  static void httpResponseValidation(response) {
    Get.snackbar("Something wrong...", "");
  }
}
