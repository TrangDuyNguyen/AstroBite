/// Centralized Gemini AI configuration and candidate models.
/// ASTRO-009: Unified source of truth for fallback models across AI features.
abstract final class GeminiConfig {
  /// Candidate Gemini models prioritized by latency and availability.
  /// Falls back sequentially on transient errors (503 / 429).
  static const List<String> candidateModels = [
    'gemini-flash-lite-latest',
    'gemini-3.5-flash',
    'gemini-3.6-flash',
    'gemini-3.5-flash-lite',
    'gemini-flash-latest',
    'gemini-3.8-flash',
  ];

  /// ASTRO-008: Evaluates if an error is a transient model availability / capacity
  /// error (503, 429, timeout, model-not-found) that warrants trying the next candidate model.
  /// Non-transient errors (auth, client input, network disconnection, safety blocks)
  /// should fail immediately without uselessly cycling candidate models.
  static bool isTransientError(Object error) {
    final str = error.toString().toLowerCase();

    // 1. Definite Non-Transient Errors (Fail immediately)
    if (str.contains('api_key_invalid') ||
        str.contains('api key not valid') ||
        str.contains('unauthenticated') ||
        str.contains('permission_denied') ||
        str.contains('socketexception') ||
        str.contains('connection refused') ||
        str.contains('failed host lookup') ||
        str.contains('blocked by safety') ||
        str.contains('safety settings') ||
        str.contains('invalid_argument')) {
      return false;
    }

    // 2. Definite Transient / Capacity / Rate Limit / Timeout Errors
    if (str.contains('503') ||
        str.contains('service unavailable') ||
        str.contains('overloaded') ||
        str.contains('high demand') ||
        str.contains('429') ||
        str.contains('resource_exhausted') ||
        str.contains('quota') ||
        str.contains('rate limit') ||
        str.contains('404') ||
        str.contains('not_found') ||
        str.contains('deadline_exceeded') ||
        str.contains('timeout')) {
      return true;
    }

    return false;
  }
}
