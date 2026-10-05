import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:astrobite/core/constants/app_keys.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/utils/json_parser.dart';
import '../models/scan_result_dto.dart';

/// Remote datasource that communicates directly with Google Gemini AI
/// via Google AI Studio API Key (Free tier, no credit card required).
class GeminiRemoteDatasource {
  GeminiRemoteDatasource({
    GenerativeModel? model,
    Future<String> Function()? apiKeyResolver,
  })  : _model = model,
        _apiKeyResolver = apiKeyResolver ?? GeminiApiKeyNotifier.getActiveKey;

  final GenerativeModel? _model;
  final Future<String> Function() _apiKeyResolver;

  static const _systemPrompt = '''
You are an expert nutritionist and computer vision AI specialized in Vietnamese cuisine and Asian culinary decomposition.
Analyze the attached image and extract all identifiable food items, their estimated weights, and calculated nutritional profiles.

You MUST return a valid, minified JSON object matching the schema below. Do NOT wrap the JSON in markdown code blocks, do NOT include any introductory or concluding text.

Schema Definition:
{
  "is_food": boolean,
  "total_calories": integer,
  "macros": {
    "protein_g": integer,
    "carbs_g": integer,
    "fat_g": integer
  },
  "sodium_mg": float,
  "fiber_g": float,
  "sugar_g": float,
  "dishes": [
    {
      "dish_name": "string",
      "confidence_score": float,
      "estimated_weight_g": integer,
      "calories": integer,
      "carbs_g": integer,
      "protein_g": integer,
      "fat_g": integer,
      "sodium_mg": float,
      "fiber_g": float,
      "sugar_g": float,
      "has_broth": boolean,
      "broth_calories": integer,
      "broth_sodium_mg": float,
      "include_broth": boolean,
      "sub_items": [
        {
          "name": "string",
          "calories": integer,
          "carbs_g": integer,
          "protein_g": integer,
          "fat_g": integer,
          "is_selected": boolean
        }
      ]
    }
  ]
}

Contextual Rules:
1. Prioritize Vietnamese traditional food profiles, street food, and authentic regional culinary ingredients.
2. For noodle soups or dishes with broth (e.g., Phở, Bún bò Huế, Hủ tiếu, Canh chua, Bánh canh, Mì Quảng):
   - Set "has_broth": true.
   - Separate "broth_calories" (bone broth, fat, simmered aromatics; usually 35-45% of total calories).
   - Separate "broth_sodium_mg" (seasoning, fish sauce, MSG in broth; usually 65-80% of total sodium).
   - "calories" is the total calories including broth.
   - Set "include_broth": true.
3. For dry or non-broth dishes, set "has_broth": false, "broth_calories": 0, "broth_sodium_mg": 0.0.
4. For composite / combo dishes with multiple customizable toppings (e.g., Cơm tấm sườn bì chả mỡ hành, Bánh mì kẹp thịt, Xôi mặn, Trà sữa trân châu):
   - Decompose distinct key toppings into the "sub_items" array with their individual calories and macros.
   - Set "is_selected": true for each sub-item.
5. If multiple items exist on one table or tray, segment each distinct item into the "dishes" array.
6. Provide accurate estimates for sodium (mg), dietary fiber (g), and sugars (g).
''';

  Future<ScanResultDto?> analyzeFoodImage(Uint8List imageBytes) async {
    if (_model != null) {
      return _generateWithModel(_model!, imageBytes);
    }

    final apiKey = await _apiKeyResolver();
    if (apiKey.isEmpty) {
      throw StateError(
        'Chưa cấu hình Gemini API Key.\n'
        'Vui lòng vào mục Hồ sơ để cài đặt API Key miễn phí từ Google AI Studio (aistudio.google.com) hoặc file .env.',
      );
    }

    return _analyzeWithKey(apiKey, imageBytes);
  }

  Future<ScanResultDto?> _analyzeWithKey(String apiKey, Uint8List imageBytes) async {
    // Prioritize active fast vision models with automatic fallback on demand spikes (503) or rate limits
    const candidateModels = [
      'gemini-3.1-flash-lite-preview',
      'gemini-flash-latest',
      'gemini-3.8-flash',
    ];

    Object? lastError;
    for (final modelName in candidateModels) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
          ),
        );
        return await _generateWithModel(model, imageBytes);
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
            return _analyzeWithKey(defaultKey, imageBytes);
          }
          rethrow;
        }

        // On capacity / high demand (503), quota / rate limit (429), timeout, or model errors,
        // automatically fallback to the next candidate model
        continue;
      }
    }

    if (lastError != null) throw lastError;
    return null;
  }

  Future<ScanResultDto?> _generateWithModel(
    GenerativeModel model,
    Uint8List imageBytes,
  ) async {
    final response = await model.generateContent([
      Content.multi([
        TextPart(_systemPrompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ]).timeout(const Duration(seconds: 14));

    final text = response.text;
    if (text == null || text.isEmpty) return null;

    final jsonMap = JsonParser.tryParseGeminiResponse(text);
    if (jsonMap == null) return null;

    return ScanResultDto.fromJson(jsonMap);
  }
}
