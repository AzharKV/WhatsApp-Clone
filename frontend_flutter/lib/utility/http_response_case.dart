import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/utility/utility.dart';

//http.Response
dynamic httpResponseCase(http.Response response, String url, String method) {
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

  return response;
}
