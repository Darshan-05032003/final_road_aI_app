import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  Locale get currentLocale => _currentLocale;
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  
  void changeLanguage(Locale newLocale) {
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      notifyListeners();
      
      // Force app rebuild using navigator key
      if (_navigatorKey.currentState?.mounted ?? false) {
        _navigatorKey.currentState!.setState(() {});
      }
    }
  }
  
  void changeLanguageByCode(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'en':
        newLocale = const Locale('en', 'US');
        break;
      case 'es':
        newLocale = const Locale('es', 'ES');
        break;
      case 'hi':
        newLocale = const Locale('hi', 'IN');
        break;
      case 'fr':
        newLocale = const Locale('fr', 'FR');
        break;
      default:
        newLocale = const Locale('en', 'US');
    }
    
    changeLanguage(newLocale);
  }

  // Convenience methods for easier language switching
  void setEnglish() => changeLanguage(const Locale('en', 'US'));
  void setSpanish() => changeLanguage(const Locale('es', 'ES'));
  void setHindi() => changeLanguage(const Locale('hi', 'IN'));
  void setFrench() => changeLanguage(const Locale('fr', 'FR'));

  // Get current language code
  String get currentLanguageCode => _currentLocale.languageCode;

  // Check if current language matches
  bool isCurrentLanguage(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }
}