import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Language state
class LanguageState extends Equatable {
  final Locale currentLocale;
  final GlobalKey<NavigatorState> navigatorKey;

  const LanguageState({
    required this.currentLocale,
    required this.navigatorKey,
  });

  /// Initial state
  factory LanguageState.initial() {
    return LanguageState(
      currentLocale: const Locale('en', 'US'),
      navigatorKey: GlobalKey<NavigatorState>(),
    );
  }

  /// Copy with method
  LanguageState copyWith({
    Locale? currentLocale,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return LanguageState(
      currentLocale: currentLocale ?? this.currentLocale,
      navigatorKey: navigatorKey ?? this.navigatorKey,
    );
  }

  /// Get current language code
  String get currentLanguageCode => currentLocale.languageCode;

  /// Check if current language matches
  bool isCurrentLanguage(String languageCode) {
    return currentLocale.languageCode == languageCode;
  }

  @override
  List<Object?> get props => [currentLocale, navigatorKey];
}
