import 'package:flutter_tts/flutter_tts.dart';

/// Lightweight wrapper around flutter_tts to centralize configuration and calls.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool initialized = false;

  Future<void> init({String locale = 'en-US', double rate = 0.45, double pitch = 1.0}) async {
    if (initialized) return;
    try {
      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(pitch);
    } catch (_) {
      // platform-specific failures are intentionally non-fatal here
    }
    initialized = true;
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    try {
      await _tts.speak(text);
    } catch (_) {
      // swallow - TTS failures shouldn't crash the app
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // ignore
    }
  }

  /// Dispose if you ever need to explicitly free resources.
  void dispose() {
    // flutter_tts doesn't have a dispose API; stop is sufficient
    stop();
  }
}
