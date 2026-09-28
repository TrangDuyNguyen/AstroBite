/// Centralized application keys and environment variables.
abstract final class AppKeys {
  /// Default Gemini API Key loaded securely from environment variable at compile time:
  /// `flutter run --dart-define-from-file=.env`
  /// or `--dart-define=GEMINI_API_KEY=your_api_key`
  ///
  /// Secure architecture:
  /// Secrets must NEVER be hardcoded into source code.
  /// Keys are injected securely via .env (git-ignored) or entered by user in UI settings.
  static const String defaultGeminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY');
}
