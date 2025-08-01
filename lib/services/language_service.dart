import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _keyLanguage = 'selected_language';
  
  static const String arabic = 'ar';
  static const String english = 'en';

  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? arabic; // Default to Arabic
  }

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  static Future<void> toggleLanguage() async {
    final currentLang = await getCurrentLanguage();
    final newLang = currentLang == arabic ? english : arabic;
    await setLanguage(newLang);
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case arabic:
        return 'العربية';
      case english:
        return 'English';
      default:
        return 'العربية';
    }
  }

  static String getLanguageNameInEnglish(String languageCode) {
    switch (languageCode) {
      case arabic:
        return 'Arabic';
      case english:
        return 'English';
      default:
        return 'Arabic';
    }
  }
} 