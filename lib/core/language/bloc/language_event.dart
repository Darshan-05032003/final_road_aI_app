import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for language events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change language
class ChangeLanguageEvent extends LanguageEvent {
  final Locale locale;

  const ChangeLanguageEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

/// Event to change language by code
class ChangeLanguageByCodeEvent extends LanguageEvent {
  final String languageCode;

  const ChangeLanguageByCodeEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

/// Event to set English language
class SetEnglishEvent extends LanguageEvent {
  const SetEnglishEvent();
}

/// Event to set Spanish language
class SetSpanishEvent extends LanguageEvent {
  const SetSpanishEvent();
}

/// Event to set Hindi language
class SetHindiEvent extends LanguageEvent {
  const SetHindiEvent();
}

/// Event to set French language
class SetFrenchEvent extends LanguageEvent {
  const SetFrenchEvent();
}
