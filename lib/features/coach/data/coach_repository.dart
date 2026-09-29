import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import 'package:astrobite/core/constants/app_keys.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import '../domain/chat_message.dart';

/// Repository handling Gemini multi-turn chat and Firestore session persistence.
class CoachRepository {
  CoachRepository({GenerativeModel? model}) : _model = model;

  final GenerativeModel? _model;
  ChatSession? _chatSession;

  static const _maxMessagesPerDay = 50;
  static const _slidingWindowSize = 10;

  static const _systemPrompt = '''
Bạn là chuyên gia dinh dưỡng AstroBite — trợ lý AI thông minh chuyên tư vấn chế độ ăn uống lành mạnh trong tiểu vũ trụ cá nhân.

Quy tắc bắt buộc:
1. Trả lời ngắn gọn, thân thiện, súc tích bằng tiếng Việt.
2. Dựa sát vào thông tin thể trạng, mục tiêu và số calo/macro còn lại trong ngày của người dùng để tư vấn.
3. KHÔNG chẩn đoán bệnh, kê đơn thuốc hoặc đưa ra lời khuyên y khoa.
4. Nếu được hỏi về y khoa, trả lời: "Tôi chỉ tư vấn về dinh dưỡng. Vui lòng tham khảo ý kiến bác sĩ chuyên khoa."
5. Khi gợi ý món ăn, luôn kèm ước tính calo và macro (protein, carbs, fat).
6. Khi gợi ý món ăn hoặc lựa chọn cho người dùng, HÃY SINH GIAO DIỆN TƯƠNG TÁC (A2UI GenUI components) đính kèm ở cuối câu trả lời theo đúng khối sau:
```a2ui
{
  "surface": "chat_cockpit",
  "components": [
    {
      "id": "comp_meal_1",
      "type": "MealQuickLogCard",
      "props": {
        "dishName": "Tên món",
        "calories": 350,
        "protein": 30.0,
        "carbs": 40.0,
        "fat": 8.0,
        "weightG": 150,
        "sodium": 210,
        "mealType": "lunch"
      }
    },
    {
      "id": "comp_gauge_1",
      "type": "MacroBudgetGauge",
      "props": {
        "projectedCalories": 350,
        "remainingCalories": 650,
        "targetCalories": 2000
      }
    },
    {
      "id": "comp_chips_1",
      "type": "QuickChoiceChips",
      "props": {
        "chips": [
          {"label": "Bữa trưa", "payload": "Tôi chọn món này cho bữa trưa"},
          {"label": "Gợi ý món khác", "payload": "Gợi ý cho tôi món khác ít calo hơn"}
        ]
      }
    }
  ]
}
```
Nếu chỉ có món ăn đơn giản, bạn có thể chỉ cần sinh `MealQuickLogCard`.
''';

  static const candidateModels = [
    'gemini-3.1-flash-lite-preview',
    'gemini-flash-latest',
    'gemini-3.8-flash',
  ];

  /// Sends a message to Gemini with daily meal context and returns AI response.
  Future<String> sendMessage({
    required String userMessage,
    required String userId,
    required String mealContext,
    required List<ChatMessage> history,
  }) async {
    if (_model != null) {
      return _sendWithModel(
        _model!,
        userMessage: userMessage,
        mealContext: mealContext,
        history: history,
      );
    }

    final apiKey = await GeminiApiKeyNotifier.getActiveKey();
    if (apiKey.isEmpty) {
      throw StateError('Gemini API Key chưa được cấu hình.');
    }

    return _sendWithKey(
      apiKey,
      userMessage: userMessage,
      userId: userId,
      mealContext: mealContext,
      history: history,
    );
  }

  Future<String> _sendWithKey(
    String apiKey, {
    required String userMessage,
    required String userId,
    required String mealContext,
    required List<ChatMessage> history,
  }) async {
    Object? lastError;
    for (final modelName in candidateModels) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          systemInstruction: Content.system(_systemPrompt),
        );
        return await _sendWithModel(
          model,
          userMessage: userMessage,
          mealContext: mealContext,
          history: history,
        );
      } catch (e) {
        lastError = e;
        final errStr = e.toString().toLowerCase();

        // If the API key is completely invalid or revoked, try default key if different, else fail fast
        if (errStr.contains('api_key_invalid') ||
            errStr.contains('api key not valid') ||
            errStr.contains('key expired') ||
            errStr.contains('invalid authentication') ||
            errStr.contains('unauthenticated') ||
            errStr.contains('oauth 2')) {
          final defaultKey = AppKeys.defaultGeminiApiKey.trim();
          if (defaultKey.isNotEmpty && apiKey != defaultKey) {
            return _sendWithKey(
              defaultKey,
              userMessage: userMessage,
              userId: userId,
              mealContext: mealContext,
              history: history,
            );
          }
          rethrow;
        }

        // On capacity / high demand (503), quota (429), not found (404), or timeout, fallback to next model
        continue;
      }
    }

    if (lastError != null) throw lastError;
    return 'Xin lỗi, tôi không thể trả lời lúc này.';
  }

  Future<String> _sendWithModel(
    GenerativeModel model, {
    required String userMessage,
    required String mealContext,
    required List<ChatMessage> history,
  }) async {
    // Build sliding window history for multi-turn (only previous messages, filter out error bubbles)
    final recentHistory = sanitizeHistory(history);

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

  /// Loads a chat session by a specific date from Firestore.
  Future<List<ChatMessage>> loadSessionByDate(String userId, String date) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(date)
        .get();

    if (!doc.exists) return [];

    final messages = doc.data()?['messages'] as List<dynamic>? ?? [];
    return messages
        .map((m) => ChatMessage.fromMap(Map<String, dynamic>.from(m as Map)))
        .toList();
  }

  /// Loads past chat sessions metadata from Firestore (most recent 30 sessions).
  Future<List<Map<String, dynamic>>> loadChatSessionsList(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .orderBy('date', descending: true)
        .limit(30)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final messages = data['messages'] as List<dynamic>? ?? [];
      final lastMsg = messages.isNotEmpty
          ? (messages.last['content'] as String? ?? '')
          : '';
      return {
        'date': doc.id,
        'message_count': data['message_count'] as int? ?? messages.length,
        'last_message': lastMsg,
      };
    }).toList();
  }

  /// Deletes a chat session for a specific date from Firestore.
  Future<void> deleteSession(String userId, String date) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(date)
        .delete();
  }

  /// Filters error bubbles and limits history to the most recent [_slidingWindowSize] messages (RSK-006 mitigation).
  static List<ChatMessage> sanitizeHistory(List<ChatMessage> history) {
    final cleanHistory = history.where((m) => !m.isError).toList();
    return cleanHistory.length > _slidingWindowSize
        ? cleanHistory.sublist(cleanHistory.length - _slidingWindowSize)
        : cleanHistory;
  }

  int get maxMessagesPerDay => _maxMessagesPerDay;
  int get slidingWindowSize => _slidingWindowSize;
}
