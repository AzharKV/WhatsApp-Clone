import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<String> readString(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  Future<void> saveString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  Future<void> remove(String key) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
}
