import 'dart:convert';
import 'a2ui_model.dart';

/// Robust parser for A2UI (Agent-to-User Interface) payloads coming from Gemini.
class A2uiParser {
  const A2uiParser();

  /// Parses raw text from the AI and returns an [A2uiMessagePayload].
  /// Handles strict JSON, fenced code blocks, hidden comment tags, and legacy fallback.
  static A2uiMessagePayload parse(String rawContent) {
    final trimmed = rawContent.trim();

    // 1. Try direct JSON parsing
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          return _parseFromMap(decoded, rawContent);
        }
      } catch (_) {
        // Fall through to pattern matching
      }
    }

    // 2. Check for fenced ```a2ui or ```json code block containing A2UI
    final a2uiBlockRegex = RegExp(
      r'```(?:a2ui|json)\s*(\{[\s\S]*?\})\s*```',
      multiLine: true,
    );
    final a2uiMatch = a2uiBlockRegex.firstMatch(trimmed);
    if (a2uiMatch != null) {
      final jsonStr = a2uiMatch.group(1);
      if (jsonStr != null) {
        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            final cleanText = trimmed.replaceAll(a2uiMatch.group(0)!, '').trim();
            final payload = _parseFromMap(decoded, cleanText);
            return A2uiMessagePayload(
              text: cleanText.isNotEmpty ? cleanText : payload.text,
              components: payload.components,
              surface: payload.surface,
            );
          }
        } catch (_) {}
      }
    }

    // 3. Check for hidden comment <!--a2ui:{...}-->
    final commentRegex = RegExp(r'<!--a2ui:(\{[\s\S]*?\})-->');
    final commentMatch = commentRegex.firstMatch(trimmed);
    if (commentMatch != null) {
      final jsonStr = commentMatch.group(1);
      if (jsonStr != null) {
        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            final cleanText = trimmed.replaceAll(commentMatch.group(0)!, '').trim();
            final payload = _parseFromMap(decoded, cleanText);
            return A2uiMessagePayload(
              text: cleanText.isNotEmpty ? cleanText : payload.text,
              components: payload.components,
              surface: payload.surface,
            );
          }
        } catch (_) {}
      }
    }

    // 4. Backwards compatibility with legacy ```astrobite-meal block
    final legacyMealRegex = RegExp(
      r'```astrobite-meal\s*(\{[\s\S]*?\})\s*```',
      multiLine: true,
    );
    final legacyMatch = legacyMealRegex.firstMatch(trimmed);
    if (legacyMatch != null) {
      final jsonStr = legacyMatch.group(1);
      if (jsonStr != null) {
        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            final cleanText = trimmed.replaceAll(legacyMatch.group(0)!, '').trim();
            return A2uiMessagePayload(
              text: cleanText,
              components: [
                A2uiComponent(
                  id: 'comp_legacy_${DateTime.now().millisecondsSinceEpoch}',
                  type: 'MealQuickLogCard',
                  props: decoded,
                ),
              ],
            );
          }
        } catch (_) {}
      }
    }

    // 5. Backwards compatibility with legacy <!--astrobite-meal:{...}-->
    final legacyCommentRegex = RegExp(r'<!--astrobite-meal:(\{[\s\S]*?\})-->');
    final legacyCommentMatch = legacyCommentRegex.firstMatch(trimmed);
    if (legacyCommentMatch != null) {
      final jsonStr = legacyCommentMatch.group(1);
      if (jsonStr != null) {
        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            final cleanText =
                trimmed.replaceAll(legacyCommentMatch.group(0)!, '').trim();
            return A2uiMessagePayload(
              text: cleanText,
              components: [
                A2uiComponent(
                  id: 'comp_legacy_${DateTime.now().millisecondsSinceEpoch}',
                  type: 'MealQuickLogCard',
                  props: decoded,
                ),
              ],
            );
          }
        } catch (_) {}
      }
    }

    // Fallback: Pure text message
    return A2uiMessagePayload(text: trimmed);
  }

  static A2uiMessagePayload _parseFromMap(
    Map<String, dynamic> map,
    String fallbackText,
  ) {
    final text = map['text']?.toString() ?? fallbackText;
    final surface = map['surface']?.toString() ?? 'chat_cockpit';
    final rawComponents = map['components'];
    final List<A2uiComponent> components = [];

    if (rawComponents is List) {
      for (final item in rawComponents) {
        if (item is Map<String, dynamic>) {
          components.add(A2uiComponent.fromMap(item));
        } else if (item is Map) {
          components.add(A2uiComponent.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    return A2uiMessagePayload(
      text: text,
      components: components,
      surface: surface,
    );
  }
}
