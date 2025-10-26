import 'package:shared_preferences/shared_preferences.dart';

class PersistenciaHelper {
  static const _chaveUsaFirebase = 'usaFirebase';

  /// Retorna true se deve usar Firebase, false se deve usar SQLite
  static Future<bool> getUsaFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveUsaFirebase) ?? false; // padrão = SQLite
  }

  /// Define se deve usar Firebase (true) ou SQLite (false)
  static Future<void> setUsaFirebase(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveUsaFirebase, valor);
  }
}
