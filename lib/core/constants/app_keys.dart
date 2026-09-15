/// Centralized application keys and environment variables.
abstract final class AppKeys {
  /// Default Gemini API Key loaded from environment variable at compile time:
  /// `flutter run --dart-define=GEMINI_API_KEY=your_api_key`
  /// or `--dart-define-from-file=.env`
  ///
  /// Get a 100% free Gemini API Key (no credit card required) at:
  /// https://aistudio.google.com/app/apikey
  static const String defaultGeminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
}
