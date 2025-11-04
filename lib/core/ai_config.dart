import 'package:smart_road_app/core/api/config.dart';

/// Central AI provider configuration.
///
/// Default provider is set to Claude Sonnet 3.5. This file only provides
/// endpoints and placeholder API keys. For production, replace placeholders
/// with secure storage or environment variables and follow vendor auth docs.

enum AiProvider { claudeSonnet35, googleGemini, openAI, custom }

class AiConfig {
  // Change the default provider here if you want a different AI as the app-wide default.
  static const AiProvider defaultProvider = AiProvider.claudeSonnet35;

  /// Returns the API key to use for the configured provider.
  /// Replace with secure retrieval in production.
  static String get apiKey {
    switch (defaultProvider) {
      case AiProvider.googleGemini:
        return APIConfig.visionAIKey; // reuse a placeholder from existing config
      case AiProvider.openAI:
        return APIConfig.openAIKey;
      case AiProvider.claudeSonnet35:
        return APIConfig.claudeApiKey;
      case AiProvider.custom:
        return '';
    }
  }

  /// Returns the HTTP endpoint to call for the configured provider.
  static String get endpoint {
    switch (defaultProvider) {
      case AiProvider.googleGemini:
        return 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
      case AiProvider.openAI:
        return 'https://api.openai.com/v1/chat/completions';
      case AiProvider.claudeSonnet35:
        // Placeholder Anthropic/Claude Sonnet 3.5 endpoint — replace with actual vendor URL.
        return 'https://api.anthropic.com/v1/claude-sonnet-3.5/generate';
      case AiProvider.custom:
        return '';
    }
  }

  /// Helper to get a provider name for logging/UI
  static String get providerName {
    switch (defaultProvider) {
      case AiProvider.googleGemini:
        return 'Google Gemini';
      case AiProvider.openAI:
        return 'OpenAI';
      case AiProvider.claudeSonnet35:
        return 'Claude Sonnet 3.5';
      case AiProvider.custom:
        return 'Custom';
    }
  }
}
