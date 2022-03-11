import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Utility {
  // http response validation
  static void httpResponseValidation(response) {
    Get.snackbar("Something wrong...", "");
  }

  void customDebugPrint(String title) {
    if (kDebugMode) debugPrint("\n$title\n", wrapWidth: 1024);
  }
}
