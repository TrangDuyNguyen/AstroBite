import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import 'package:astrobite/core/services/gemini_api_key_service.dart';
import '../domain/chat_message.dart';

/// Repository handling Gemini multi-turn chat and Firestore session persistence.
class CoachRepository {
  CoachRepository({GenerativeModel? model}) : _model = model;

  GenerativeModel? _model;
  ChatSession? _chatSession;

  static const _maxMessagesPerDay = 50;
  static const _slidingWindowSize = 10;

  static const _systemPrompt = '''
Bạn là chuyên gia dinh dưỡng AstroBite — trợ lý AI thông minh chuyên tư vấn chế độ ăn uống lành mạnh.

Quy tắc bắt buộc:
1. Trả lời ngắn gọn, thân thiện, bằng tiếng Việt.
2. Tập trung vào dinh dưỡng, chế độ ăn, gợi ý thực đơn và cân bằng macro.
3. KHÔNG chẩn đoán bệnh, kê đơn thuốc hoặc đưa ra lời khuyên y khoa.
4. Nếu được hỏi về y khoa, trả lời: "Tôi chỉ tư vấn về dinh dưỡng. Vui lòng tham khảo ý kiến bác sĩ chuyên khoa."
5. Khi gợi ý món ăn, luôn kèm ước tính calo và macro (protein, carbs, fat).
''';

  Future<GenerativeModel> _getModel() async {
    if (_model != null) return _model!;
    final apiKey = await GeminiApiKeyNotifier.getActiveKey();
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    return _model!;
  }

  /// Sends a message to Gemini with daily meal context and returns AI response.
  Future<String> sendMessage({
    required String userMessage,
    required String userId,
    required String mealContext,
    required List<ChatMessage> history,
  }) async {
    final model = await _getModel();

    // Build sliding window history for multi-turn
    final recentHistory = history.length > _slidingWindowSize
        ? history.sublist(history.length - _slidingWindowSize)
        : history;

    _chatSession = model.startChat(
      history: [
        // Inject meal context as first user-model exchange
        Content.text('Ngữ cảnh bữa ăn hôm nay: $mealContext'),
        Content.model([TextPart('Đã nhận ngữ cảnh. Tôi sẵn sàng tư vấn.')]),
        // Replay recent conversation history
        ...recentHistory.map(
          (msg) => msg.isUser
              ? Content.text(msg.content)
              : Content.model([TextPart(msg.content)]),
        ),
      ],
    );

    final response = await _chatSession!.sendMessage(
      Content.text(userMessage),
    );

    return response.text ?? 'Xin lỗi, tôi không thể trả lời lúc này.';
  }

  /// Loads today's chat session from Firestore.
  Future<List<ChatMessage>> loadTodaySession(String userId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(today)
        .get();

    if (!doc.exists) return [];

    final messages = doc.data()?['messages'] as List<dynamic>? ?? [];
    return messages
        .map((m) => ChatMessage.fromMap(Map<String, dynamic>.from(m as Map)))
        .toList();
  }

  /// Saves a message to today's Firestore session.
  Future<void> saveMessage(String userId, ChatMessage message) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(today);

    await ref.set({
      'date': today,
      'user_id': userId,
      'last_message_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await ref.update({
      'messages': FieldValue.arrayUnion([message.toMap()]),
      'message_count': FieldValue.increment(1),
    });
  }

  /// Checks if user has reached the daily message limit.
  Future<int> getTodayMessageCount(String userId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(today)
        .get();

    return doc.data()?['message_count'] as int? ?? 0;
  }

  int get maxMessagesPerDay => _maxMessagesPerDay;
}
