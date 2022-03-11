class AppException implements Exception {
  final String _message;

  AppException(this._message);

  @override
  String toString() {
    return " $_message";
  }
}
