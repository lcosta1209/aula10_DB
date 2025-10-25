import 'package:shared_preferences/shared_preferences.dart';

class PersistenceMode {
  static const String _key = 'useFirebase';

  static Future<bool> getUseFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true; // false = SQLite, true = Firebase
  }

  static Future<void> setUseFirebase(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}