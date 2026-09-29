import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/data/coach_repository.dart';
import 'package:astrobite/features/coach/domain/chat_message.dart';

void main() {
  group('CoachRepository Tests', () {
    test('candidateModels prioritizes low-latency gemini-3.1-flash-lite-preview', () {
      expect(CoachRepository.candidateModels.first, 'gemini-3.1-flash-lite-preview');
      expect(CoachRepository.candidateModels, contains('gemini-flash-latest'));
      expect(CoachRepository.candidateModels, contains('gemini-3.8-flash'));
    });

    test('daily message limit constraint is maintained', () {
      final repo = CoachRepository();
      expect(repo.maxMessagesPerDay, 50);
      expect(repo.slidingWindowSize, 10);
    });

    group('RSK-006: Context Sliding Window & Sanitization', () {
      test('keeps all messages if under sliding window size and no errors', () {
        final messages = List.generate(
          5,
          (i) => ChatMessage(
            id: 'msg_$i',
            role: i.isEven ? 'user' : 'assistant',
            content: 'Message $i',
            timestamp: DateTime(2026, 9, 29, 10, i),
          ),
        );

        final result = CoachRepository.sanitizeHistory(messages);
        expect(result.length, 5);
        expect(result.first.content, 'Message 0');
        expect(result.last.content, 'Message 4');
      });

      test('filters out error bubbles completely', () {
        final messages = [
          ChatMessage(
            id: '1',
            role: 'user',
            content: 'Hello',
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '2',
            role: 'assistant',
            content: 'Error: Connection lost',
            isError: true,
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            id: '3',
            role: 'user',
            content: 'How many calories in an apple?',
            timestamp: DateTime.now(),
          ),
        ];

        final result = CoachRepository.sanitizeHistory(messages);
        expect(result.length, 2);
        expect(result.any((m) => m.isError), isFalse);
        expect(result[0].content, 'Hello');
        expect(result[1].content, 'How many calories in an apple?');
      });

      test('slides window to exactly the last 10 clean messages when history is large', () {
        final messages = List.generate(
          20,
          (i) => ChatMessage(
            id: 'msg_$i',
            role: i.isEven ? 'user' : 'assistant',
            content: 'Content $i',
            isError: i == 12, // Message 12 is an error
            timestamp: DateTime(2026, 9, 29, 10, i),
          ),
        );

        // 20 messages minus 1 error = 19 clean messages.
        // Sliding window of 10 should yield the last 10 clean messages: index 10 to 19 (excluding 12).
        final result = CoachRepository.sanitizeHistory(messages);
        expect(result.length, 10);
        expect(result.any((m) => m.isError), isFalse);
        expect(result.last.content, 'Content 19');
        expect(result.first.content, 'Content 9');
      });
    });
  });
}
