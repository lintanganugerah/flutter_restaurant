import 'package:restaurant_flutter/model/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final SharedPreferences _pref;

  SettingsService(this._pref);

  static const String _kDarkModeKey = 'isDarkMode';

  //Kita load berdasarkan dari shared Preferences
  Future<Setting> loadSettings() async {
    return Setting(
      isDarkMode: _pref.getBool(_kDarkModeKey) ?? false, // Default value false
    );
  }

  //Simpan settings ke shared preferences
  Future<void> saveDarkMode(bool isDarkMode) async {
    try {
      await _pref.setBool(_kDarkModeKey, isDarkMode);
    } catch (e) {
      throw Exception("Failed to save dark mode setting.");
    }
  }
}
