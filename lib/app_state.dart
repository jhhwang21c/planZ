import 'package:shared_preferences/shared_preferences.dart';

class AppLangState {
  // Private constructor
  AppLangState._privateConstructor();

  // Singleton instance
  static final AppLangState instance = AppLangState._privateConstructor();

  // App language
  String _appLanguage = 'en'; // Default language

  // Getter for app language
  String get appLanguage => _appLanguage;

  // Setter for app language with persistence
  Future<void> setAppLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', language);
    _appLanguage = language;
    print(_appLanguage);
  }

  // Load language preference from SharedPreferences
  Future<void> loadAppLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _appLanguage = prefs.getString('app_language') ?? 'en';
  }
}