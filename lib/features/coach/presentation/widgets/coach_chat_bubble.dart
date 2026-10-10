import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/genui/a2ui_model.dart';
import 'package:astrobite/core/genui/a2ui_parser.dart';
import 'package:astrobite/core/genui/catalog.dart';
import 'package:astrobite/core/genui/catalog_item.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import '../../domain/chat_message.dart';
import 'coach_meal_card.dart';

/// Chat message bubble for both user and AI responses.
class CoachChatBubble extends StatelessWidget {
  const CoachChatBubble({
    super.key,
    required this.message,
    required this.isLogged,
    required this.genUiCatalog,
    required this.onLogMeal,
    required this.onSendUserMessage,
    required this.onRetry,
  });

  final ChatMessage message;
  final bool isLogged;
  final GenUiCatalog genUiCatalog;
  final void Function(String messageId, Map<String, dynamic> mealData) onLogMeal;
  final void Function(String prompt) onSendUserMessage;
  final VoidCallback onRetry;

  static Map<String, dynamic>? extractMealData(String content) {
    // 1. Try markdown code block ```astrobite-meal ... ```
    final blockMatch = RegExp(r'```(?:astrobite-meal|json)?\s*(\{.*?"dishName".*?\})\s*```', dotAll: true).firstMatch(content)
        ?? RegExp(r'```astrobite-meal\s*(\{.*?\})\s*```', dotAll: true).firstMatch(content);
    if (blockMatch != null) {
      try {
        final jsonStr = blockMatch.group(1)?.trim();
        if (jsonStr != null) {
          return jsonDecode(jsonStr) as Map<String, dynamic>;
        }
      } catch (_) {}
    }

    // 2. Try HTML comment <!--astrobite-meal:...-->
    final commentMatch = RegExp(r'<!--astrobite-meal:(.*?)-->', dotAll: true).firstMatch(content);
    if (commentMatch != null) {
      try {
        return jsonDecode(commentMatch.group(1)!) as Map<String, dynamic>;
      } catch (_) {}
    }

    return null;
  }

  static String cleanDisplayContent(String content) {
    return content
        .replaceAll(RegExp(r'```(?:astrobite-meal|json)?\s*\{.*?"dishName".*?\}\s*```', dotAll: true), '')
        .replaceAll(RegExp(r'```astrobite-meal\s*\{.*?\}\s*```', dotAll: true), '')
        .replaceAll(RegExp(r'<!--astrobite-meal:.*?-->', dotAll: true), '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final a2uiPayload = isUser
        ? A2uiMessagePayload(text: message.content)
        : A2uiParser.parse(message.content);
    final displayContent = isUser
        ? message.content
        : (a2uiPayload.text.isNotEmpty
            ? a2uiPayload.text
            : cleanDisplayContent(message.content));
    final mealData = extractMealData(message.content);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFE0F2FE) : Colors.white,
          border: Border.all(
            color: isUser
                ? const Color(0xFFBAE6FD)
                : (message.isError ? AppColors.tertiary : const Color(0xFFE5E0D8)),
            width: 1.2,
          ),
          boxShadow: isUser
              ? const [
                  BoxShadow(
                    color: Color(0xFFBAE6FD),
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0xFFD4CEBF),
                    offset: Offset(0, 2.5),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x081E2337),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 18 : 4),
            topRight: Radius.circular(isUser ? 4 : 18),
            bottomLeft: const Radius.circular(18),
            bottomRight: const Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isError) ...[
              const Text('⚠️', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
            ],
            if (displayContent.isNotEmpty)
              isUser || message.isError
                  ? Text(
                      displayContent,
                      style: GoogleFonts.inter(
                        color: AppColors.onSurface,
                        fontSize: 14.5,
                        fontWeight: isUser ? FontWeight.w600 : FontWeight.w400,
                        height: 1.4,
                      ),
                    )
                  : MarkdownBody(
                      data: displayContent,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.inter(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          height: 1.45,
                        ),
                        h3: GoogleFonts.outfit(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                        strong: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        listBullet: GoogleFonts.inter(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        horizontalRuleDecoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFE5E0D8),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
            // GenUI Dynamic A2UI Components
            if (!isUser && a2uiPayload.hasComponents && mealData == null) ...[
              for (final comp in a2uiPayload.components) ...[
                const SizedBox(height: 10),
                genUiCatalog.buildWidget(
                  context,
                  comp,
                  CatalogItemContext(
                    isLogged: isLogged,
                    onAction: (action, payload) {
                      if (action == 'log_meal' && payload is Map<String, dynamic>) {
                        onLogMeal(message.id, payload);
                      }
                    },
                    onSendUserMessage: (prompt) => onSendUserMessage(prompt),
                  ),
                ),
              ],
            ] else if (mealData != null) ...[
              const SizedBox(height: 10),
              CoachMealCard(
                message: message,
                mealData: mealData,
                isLogged: isLogged,
                onLogMeal: () => onLogMeal(message.id, mealData),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(width: 6),
                  Text(
                    '• AstroCoach',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
            if (message.isError) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Thử lại'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                  ),
                  if (message.content.contains('API Key'))
                    FilledButton.tonalIcon(
                      onPressed: () => GeminiApiKeyDialog.show(context),
                      icon: const Icon(Icons.vpn_key_rounded, size: 16),
                      label: const Text('Cài đặt API Key'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF7ED),
                        foregroundColor: AppColors.tertiary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
