import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _kDarkModeKey = 'is_dark_mode';
  static const String _kLanguageKey = 'language_code';

  bool _isDarkMode = false;
  Locale _locale = const Locale('es');
  final SharedPreferences _prefs;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;

  void _loadSettings() {
    _isDarkMode = _prefs.getBool(_kDarkModeKey) ?? false;
    final langCode = _prefs.getString(_kLanguageKey) ?? 'es';
    _locale = Locale(langCode);
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_kDarkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _prefs.setString(_kLanguageKey, languageCode);
    notifyListeners();
  }
}
