/// Centralized application keys and environment variables.
abstract final class AppKeys {
  /// Default Gemini API Key loaded securely from environment variable at compile time:
  /// `flutter run --dart-define-from-file=.env`
  /// or `--dart-define=GEMINI_API_KEY=your_api_key`
  ///
  /// Secure architecture (ASTRO-005):
  /// In production releases without compile-time keys, AI requests route securely
  /// through backend Cloud Function `geminiProxy`, completely preventing API key extraction
  /// from client binaries. Custom BYOK (Bring-Your-Own-Key) is also supported in settings.
  static const String defaultGeminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY');

  /// Indicates whether the application is running in secure backend proxy mode.
  static bool get isProxyMode => defaultGeminiApiKey.isEmpty;
}
