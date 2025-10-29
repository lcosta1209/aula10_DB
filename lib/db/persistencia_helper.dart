import 'package:shared_preferences/shared_preferences.dart';

class PersistenciaHelper {
  static const _chaveUsaFirebase = 'usaFirebase';

  static Future<bool> getUsaFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveUsaFirebase) ?? false; // padrão = SQLite
  }

  static Future<void> setUsaFirebase(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveUsaFirebase, valor);
  }
}
