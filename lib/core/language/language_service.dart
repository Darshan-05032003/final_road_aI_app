import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  
  void changeLanguage(Locale newLocale) {
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      notifyListeners();
      // Force rebuild by triggering a microtask
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
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
    
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      notifyListeners();
      // Force rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}