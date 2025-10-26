import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _key = 'useFirebase';

  static Future<bool> getUseFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setUseFirebase(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
