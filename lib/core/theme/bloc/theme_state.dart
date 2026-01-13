import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme state
class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const ThemeState({
    required this.themeMode,
    this.lightTheme,
    this.darkTheme,
  });

  /// Initial state
  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeMode.light,
    );
  }

  /// Copy with method
  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  /// Get current theme based on mode
  ThemeData? get currentTheme {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        // Return light theme as default, system will handle it
        return lightTheme;
    }
  }

  @override
  List<Object?> get props => [themeMode, lightTheme, darkTheme];
}
