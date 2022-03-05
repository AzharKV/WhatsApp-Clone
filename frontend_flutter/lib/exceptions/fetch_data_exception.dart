import 'app_exception.dart';

class FetchDataException extends AppException {
  FetchDataException(String message) : super(message) {
    //Get.snackbar(message, "");
  }
}
