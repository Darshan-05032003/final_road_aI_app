import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// Theme Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeBloc() : super(ThemeState.initial()) {
    on<ChangeThemeModeEvent>(_onChangeThemeMode);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);
    on<SetLightThemeEvent>(_onSetLightTheme);
    on<SetDarkThemeEvent>(_onSetDarkTheme);
    on<SetSystemThemeEvent>(_onSetSystemTheme);

    // Load theme on initialization
    add(const LoadThemeEvent());
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      emit(state.copyWith(themeMode: event.themeMode));

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String themeString;
      
      switch (event.themeMode) {
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

  void _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    add(ChangeThemeModeEvent(newMode));
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String themeString = prefs.getString(_themeKey) ?? 'light';
      
      ThemeMode themeMode;
      switch (themeString) {
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
        case 'system':
          themeMode = ThemeMode.system;
          break;
        case 'light':
        default:
          themeMode = ThemeMode.light;
          break;
      }

      // Load themes from AppTheme
      final lightTheme = AppTheme.lightTheme;
      final darkTheme = AppTheme.darkTheme;

      emit(state.copyWith(
        themeMode: themeMode,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      ));
    } catch (e) {
      print('Error loading theme mode: $e');
    }
  }

  void _onSetLightTheme(
    SetLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    add(const ChangeThemeModeEvent(ThemeMode.light));
  }

  void _onSetDarkTheme(
    SetDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    add(const ChangeThemeModeEvent(ThemeMode.dark));
  }

  void _onSetSystemTheme(
    SetSystemThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    add(const ChangeThemeModeEvent(ThemeMode.system));
  }
}
