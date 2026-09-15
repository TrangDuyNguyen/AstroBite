import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:astrobite/core/utils/json_parser.dart';
import '../models/scan_result_dto.dart';

/// Datasource that calls Gemini API through Firebase AI Logic.
///
/// This routes all requests through the Firebase backend, so no API key
/// is ever exposed in client-side code. Firebase App Check provides
/// additional abuse protection.
class GeminiRemoteDatasource {
  GeminiRemoteDatasource({
    GenerativeModel? model,
    FirebaseAppCheck? appCheck,
  })  : _appCheck = appCheck ?? FirebaseAppCheck.instance,
        _model = model ??
            FirebaseAI.googleAI(
              appCheck: appCheck ?? FirebaseAppCheck.instance,
            ).generativeModel(
              model: 'gemini-2.0-flash',
            );

  final FirebaseAppCheck _appCheck;
  final GenerativeModel _model;

  static const _systemPrompt = '''
You are an expert nutritionist and computer vision AI specialized in Vietnamese cuisine and global food mapping.
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
  "dishes": [
    {
      "dish_name": "string",
      "confidence_score": float,
      "estimated_weight_g": integer,
      "calories": integer
    }
  ]
}

Contextual Rules:
1. Prioritize Vietnamese traditional food profiles and default ingredients.
2. If multiple items exist on one plate, segment them into the "dishes" array.
''';

  Future<ScanResultDto?> analyzeFoodImage(Uint8List imageBytes) async {
    try {
      final token = await _appCheck.getToken();
      debugPrint('[AstroBite] AppCheck token: ${token != null && token.length > 8 ? "${token.substring(0, 8)}..." : token}');
    } catch (e) {
      debugPrint('[AstroBite] Warning: error getting AppCheck token: $e');
    }

    final response = await _model.generateContent([
      Content.multi([
        TextPart(_systemPrompt),
        InlineDataPart('image/jpeg', imageBytes),
      ]),
    ]);

    final text = response.text;
    if (text == null || text.isEmpty) return null;

    final jsonMap = JsonParser.tryParseGeminiResponse(text);
    if (jsonMap == null) return null;

    return ScanResultDto.fromJson(jsonMap);
  }
}
