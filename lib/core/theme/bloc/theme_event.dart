import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for theme events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change theme mode
class ChangeThemeModeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeThemeModeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// Event to toggle theme (light/dark)
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

/// Event to load theme from storage
class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}

/// Event to set light theme
class SetLightThemeEvent extends ThemeEvent {
  const SetLightThemeEvent();
}

/// Event to set dark theme
class SetDarkThemeEvent extends ThemeEvent {
  const SetDarkThemeEvent();
}

/// Event to set system theme
class SetSystemThemeEvent extends ThemeEvent {
  const SetSystemThemeEvent();
}
