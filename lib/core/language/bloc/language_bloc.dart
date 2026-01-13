import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

/// Language Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState.initial()) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<ChangeLanguageByCodeEvent>(_onChangeLanguageByCode);
    on<SetEnglishEvent>(_onSetEnglish);
    on<SetSpanishEvent>(_onSetSpanish);
    on<SetHindiEvent>(_onSetHindi);
    on<SetFrenchEvent>(_onSetFrench);
  }

  void _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) {
    if (state.currentLocale != event.locale) {
      emit(state.copyWith(currentLocale: event.locale));
    }
  }

  void _onChangeLanguageByCode(
    ChangeLanguageByCodeEvent event,
    Emitter<LanguageState> emit,
  ) {
    Locale newLocale;
    switch (event.languageCode) {
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
    
    add(ChangeLanguageEvent(newLocale));
  }

  void _onSetEnglish(
    SetEnglishEvent event,
    Emitter<LanguageState> emit,
  ) {
    add(const ChangeLanguageEvent(Locale('en', 'US')));
  }

  void _onSetSpanish(
    SetSpanishEvent event,
    Emitter<LanguageState> emit,
  ) {
    add(const ChangeLanguageEvent(Locale('es', 'ES')));
  }

  void _onSetHindi(
    SetHindiEvent event,
    Emitter<LanguageState> emit,
  ) {
    add(const ChangeLanguageEvent(Locale('hi', 'IN')));
  }

  void _onSetFrench(
    SetFrenchEvent event,
    Emitter<LanguageState> emit,
  ) {
    add(const ChangeLanguageEvent(Locale('fr', 'FR')));
  }
}
