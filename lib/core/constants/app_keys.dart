/// Centralized application keys and environment variables.
abstract final class AppKeys {
  /// Default Gemini API Key loaded from environment variable at compile time:
  /// `flutter run --dart-define=GEMINI_API_KEY=your_api_key`
  /// or `--dart-define-from-file=.env`
  ///
  /// Fallback to the project's built-in key so users never have to configure keys manually.
  static const String defaultGeminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AQ.Ab8RN6I9cq6Jr_M2FXr9ogp-dmBKnvNhOdRMFAQoGgyin2dtXA',
  );
}
