import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/gemini_config.dart';

void main() {
  group('GeminiConfig Tests (ASTRO-008 & ASTRO-009)', () {
    test('contains ordered candidate models for fallback', () {
      expect(GeminiConfig.candidateModels, isNotEmpty);
      expect(GeminiConfig.candidateModels, contains('gemini-flash-lite-latest'));
      expect(GeminiConfig.candidateModels, contains('gemini-3.5-flash'));
    });

    test('isTransientError returns true for transient capacity/rate limit/timeout errors', () {
      expect(GeminiConfig.isTransientError(Exception('503 Service Unavailable')), isTrue);
      expect(GeminiConfig.isTransientError(Exception('Resource Exhausted: 429 Quota Exceeded')), isTrue);
      expect(GeminiConfig.isTransientError(Exception('Deadline exceeded / request timeout')), isTrue);
      expect(GeminiConfig.isTransientError(Exception('Model not found 404')), isTrue);
      expect(GeminiConfig.isTransientError(Exception('Overloaded with high demand')), isTrue);
    });

    test('isTransientError returns false for non-transient auth/safety/socket errors', () {
      expect(GeminiConfig.isTransientError(Exception('API_KEY_INVALID')), isFalse);
      expect(GeminiConfig.isTransientError(Exception('unauthenticated access')), isFalse);
      expect(GeminiConfig.isTransientError(Exception('SocketException: Failed host lookup')), isFalse);
      expect(GeminiConfig.isTransientError(Exception('Candidate was blocked by safety settings')), isFalse);
      expect(GeminiConfig.isTransientError(Exception('invalid_argument')), isFalse);
    });
  });
}

