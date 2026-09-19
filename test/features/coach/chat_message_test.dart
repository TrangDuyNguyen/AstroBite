import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/domain/chat_message.dart';

void main() {
  group('ChatMessage Entity Tests', () {
    test('instantiates user message correctly', () {
      final now = DateTime(2026, 9, 19, 10, 30);
      final msg = ChatMessage(
        id: 'msg-1',
        role: 'user',
        content: 'Bữa tối nên ăn gì?',
        timestamp: now,
      );

      expect(msg.id, equals('msg-1'));
      expect(msg.role, equals('user'));
      expect(msg.content, equals('Bữa tối nên ăn gì?'));
      expect(msg.isUser, isTrue);
      expect(msg.isAssistant, isFalse);
      expect(msg.isError, isFalse);
    });

    test('instantiates assistant message correctly', () {
      final now = DateTime(2026, 9, 19, 10, 31);
      final msg = ChatMessage(
        id: 'msg-2',
        role: 'assistant',
        content: 'Bạn có thể ăn ức gà áp chảo và bông cải xanh.',
        timestamp: now,
      );

      expect(msg.isUser, isFalse);
      expect(msg.isAssistant, isTrue);
      expect(msg.isError, isFalse);
    });

    test('toMap and fromMap serialize and deserialize accurately', () {
      final now = DateTime(2026, 9, 19, 10, 32);
      final original = ChatMessage(
        id: 'msg-serial',
        role: 'assistant',
        content: 'Gợi ý salad cá hồi',
        timestamp: now,
        isError: false,
      );

      final map = original.toMap();
      expect(map['id'], equals('msg-serial'));
      expect(map['role'], equals('assistant'));
      expect(map['content'], equals('Gợi ý salad cá hồi'));
      expect(map['timestamp'], equals(now.toIso8601String()));
      expect(map['is_error'], isFalse);

      final restored = ChatMessage.fromMap(map);
      expect(restored.id, equals(original.id));
      expect(restored.role, equals(original.role));
      expect(restored.content, equals(original.content));
      expect(restored.timestamp, equals(original.timestamp));
      expect(restored.isError, equals(original.isError));
    });

    test('handles error message flag properly', () {
      final now = DateTime(2026, 9, 19, 10, 33);
      final errorMsg = ChatMessage(
        id: 'msg-err',
        role: 'assistant',
        content: 'AI đang bận, vui lòng thử lại.',
        timestamp: now,
        isError: true,
      );

      expect(errorMsg.isError, isTrue);
      expect(errorMsg.isAssistant, isTrue);

      final map = errorMsg.toMap();
      expect(map['is_error'], isTrue);
      final restored = ChatMessage.fromMap(map);
      expect(restored.isError, isTrue);
    });
  });
}
