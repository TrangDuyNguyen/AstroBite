import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../../domain/chat_message.dart';

/// Holographic meal suggestion card rendered in AI chat bubbles.
class CoachMealCard extends StatelessWidget {
  const CoachMealCard({
    super.key,
    required this.message,
    required this.mealData,
    required this.isLogged,
    required this.onLogMeal,
  });

  final ChatMessage message;
  final Map<String, dynamic> mealData;
  final bool isLogged;
  final VoidCallback onLogMeal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dishName = mealData['dishName']?.toString() ?? l10n.suggestedDish;
    final calories = mealData['calories'] ?? 0;
    final protein = mealData['protein'] ?? 0;
    final carbs = mealData['carbs'] ?? 0;
    final fat = mealData['fat'] ?? 0;
    final sodium = mealData['sodium'];
    final ingredients = mealData['ingredients'] as List<dynamic>?;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🍲', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dishName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$calories kcal • ${protein}g P • ${carbs}g C • ${fat}g F',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.protein.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$calories kcal',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.protein,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Macro badges row
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildMacroBadge(l10n.proteinShort, '${protein}g', AppColors.protein),
              _buildMacroBadge(l10n.carbsShort, '${carbs}g', AppColors.carbs),
              _buildMacroBadge(l10n.fatShort, '${fat}g', AppColors.fat),
              if (sodium != null)
                _buildMacroBadge(l10n.sodiumShort, '${sodium}mg', AppColors.warning),
            ],
          ),
          if (ingredients != null && ingredients.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l10n.ingredientsLabel(ingredients.join(', ')),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 10),
          // 1-Tap Log CTA Action Button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: isLogged
                ? OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00E676),
                      side: const BorderSide(color: Color(0xFF00E676)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: null,
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: Text(
                      l10n.quickLogged,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                : FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onLogMeal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        const Text(
                          '⚡ 1-Tap Log • ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.tapToLog,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
