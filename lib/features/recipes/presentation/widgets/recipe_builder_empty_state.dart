import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Empty state card displayed when no ingredients have been added yet.
class RecipeBuilderEmptyState extends StatelessWidget {
  const RecipeBuilderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      elevation: 2.0,
      borderRadius: 18.0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6F2),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEDE8DD), width: 1.2),
            ),
            child: const Icon(
              Icons.soup_kitchen_rounded,
              color: AppColors.onSurfaceVariant,
              size: 26,
            ),
          ),
          const SizedBox(height: AppValues.spacing12),
          const Text(
            'Chưa có nguyên liệu nào',
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Nhấn nút "+ Thêm" ở trên để đưa nguyên liệu vào công thức.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error banner widget displaying validation or submission errors.
class RecipeBuilderErrorBanner extends StatelessWidget {
  const RecipeBuilderErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFAC4D2), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper label for section headers in recipe forms.
class RecipeSectionLabel extends StatelessWidget {
  const RecipeSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.1,
      ),
    );
  }
}
