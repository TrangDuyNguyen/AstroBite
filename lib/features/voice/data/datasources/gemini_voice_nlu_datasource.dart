import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/utils/json_parser.dart';
import '../../domain/entities/voice_log_result.dart';

/// Gemini 2.0 Flash NLU datasource for natural Vietnamese food voice transcripts.
class GeminiVoiceNluDatasource {
  GeminiVoiceNluDatasource({
    GenerativeModel? model,
    Future<String> Function()? apiKeyResolver,
  })  : _model = model,
        _apiKeyResolver = apiKeyResolver ?? GeminiApiKeyNotifier.getActiveKey;

  final GenerativeModel? _model;
  final Future<String> Function() _apiKeyResolver;

  static const _nluSystemPrompt = '''
You are an expert Vietnamese nutritionist and Natural Language Understanding (NLU) AI for AstroBite.
You analyze Vietnamese natural speech transcripts of eaten meals and extract a structured nutritional profile.

Rules:
1. Determine meal_type:
   - If transcript mentions "sáng", "điểm tâm" -> breakfast
   - If "trưa" -> lunch
   - If "tối" -> dinner
   - If "chiều", "xế", "khuya", "ăn vặt", "phụ" -> snack
   - If not mentioned, use the provided inferred_meal_type.
2. Decompose dishes:
   - Identify each item with realistic colloquial weight (bát/tô ~500-600g, đĩa ~400-500g, quả/trái ~100-150g, ly/cốc ~250-350ml, cái quẩy ~40g).
   - Accurately calculate calories, protein_g, carbs_g, fat_g, and sodium_mg.
3. Response MUST be valid minified JSON adhering to this schema:
{
  "meal_type": "breakfast" | "lunch" | "dinner" | "snack",
  "total_calories": integer,
  "protein_g": float,
  "carbs_g": float,
  "fat_g": float,
  "sodium_mg": float,
  "confidence_score": float,
  "dishes": [
    {
      "dish_name": "string",
      "estimated_weight_g": integer,
      "calories": integer,
      "protein_g": float,
      "carbs_g": float,
      "fat_g": float,
      "notes": "string"
    }
  ]
}
''';

  static String inferMealType(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final totalMinutes = hour * 60 + minute;

    if (totalMinutes >= 5 * 60 && totalMinutes <= 10 * 60 + 30) {
      return 'breakfast';
    } else if (totalMinutes > 10 * 60 + 30 && totalMinutes <= 14 * 60) {
      return 'lunch';
    } else if (totalMinutes > 14 * 60 && totalMinutes <= 17 * 60 + 30) {
      return 'snack';
    } else if (totalMinutes > 17 * 60 + 30 && totalMinutes <= 22 * 60) {
      return 'dinner';
    } else {
      return 'snack';
    }
  }

  Future<VoiceLogResult> parseTranscript(
    String transcript, {
    DateTime? now,
  }) async {
    final cleanText = transcript.trim();
    if (cleanText.isEmpty) {
      throw ArgumentError('Transcript cannot be empty');
    }

    final currentTime = now ?? DateTime.now();
    final fallbackMeal = inferMealType(currentTime);

    final promptText = '''
User transcript: "$cleanText"
Current time: ${currentTime.toIso8601String()}
Inferred default meal type: $fallbackMeal

Extract the nutritional information in strict JSON.
''';

    GenerativeModel activeModel;
    final model = _model;
    if (model != null) {
      activeModel = model;
    } else {
      final apiKey = await _apiKeyResolver();
      activeModel = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(_nluSystemPrompt),
      );
    }

    final response = await activeModel.generateContent([
      Content.text(promptText),
    ]);

    final rawJson = response.text;
    if (rawJson == null || rawJson.isEmpty) {
      throw Exception('Empty response from Gemini Voice NLU');
    }

    final jsonMap = JsonParser.tryParseGeminiResponse(rawJson);
    if (jsonMap == null) {
      throw FormatException('Failed to parse Gemini Voice NLU JSON: $rawJson');
    }

    final mealType = jsonMap['meal_type']?.toString() ?? fallbackMeal;
    final totalCalories = (jsonMap['total_calories'] as num?)?.round() ?? 0;
    final proteinG = (jsonMap['protein_g'] as num?)?.toDouble() ?? 0.0;
    final carbsG = (jsonMap['carbs_g'] as num?)?.toDouble() ?? 0.0;
    final fatG = (jsonMap['fat_g'] as num?)?.toDouble() ?? 0.0;
    final sodiumMg = (jsonMap['sodium_mg'] as num?)?.toDouble();
    final confidence = (jsonMap['confidence_score'] as num?)?.toDouble() ?? 0.92;

    final rawDishes = jsonMap['dishes'] as List<dynamic>? ?? [];
    final dishes = rawDishes
        .whereType<Map<String, dynamic>>()
        .map((d) => VoiceDishItem.fromMap(d))
        .toList();

    return VoiceLogResult(
      rawTranscript: cleanText,
      mealType: mealType,
      totalCalories: totalCalories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      sodiumMg: sodiumMg,
      dishes: dishes,
      confidenceScore: confidence,
      createdAt: currentTime,
    );
  }
}
