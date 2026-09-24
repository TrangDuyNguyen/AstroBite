import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/data/coach_repository.dart';

void main() {
  group('CoachRepository Tests', () {
    test('candidateModels prioritizes low-latency gemini-3-flash-preview', () {
      expect(CoachRepository.candidateModels.first, 'gemini-3-flash-preview');
      expect(CoachRepository.candidateModels, contains('gemini-3.6-flash'));
      expect(CoachRepository.candidateModels, contains('gemini-flash-latest'));
    });

    test('daily message limit constraint is maintained', () {
      final repo = CoachRepository();
      expect(repo.maxMessagesPerDay, 50);
    });
  });
}
