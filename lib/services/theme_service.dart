import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeService() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String themeString = prefs.getString(_themeKey) ?? 'light';
      
      _themeMode = themeString == 'dark' 
          ? ThemeMode.dark 
          : themeString == 'system'
          ? ThemeMode.system
          : ThemeMode.light;
      
      notifyListeners();
    } catch (e) {
      print('Error loading theme mode: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String themeString;
      
      switch (mode) {
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
        case ThemeMode.light:
          themeString = 'light';
          break;
      }
      
      await prefs.setString(_themeKey, themeString);
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }

  ThemeData getLightTheme() {
    return AppTheme.lightTheme;
  }

  ThemeData getDarkTheme() {
    return AppTheme.darkTheme;
  }
}

