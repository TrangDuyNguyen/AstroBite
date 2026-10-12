import 'package:flutter/material.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Modal bottom sheet displaying detailed micronutrients breakdown (Sodium, Fiber, Sugar).
/// Keeps the main Dashboard compact and prevents layout stretching.
class ClayMicronutrientSheet extends StatelessWidget {
  const ClayMicronutrientSheet({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  static Future<void> show(BuildContext context, DailySummary summary) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClayMicronutrientSheet(summary: summary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x201E2337),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: AppValues.spacing12,
        left: AppValues.screenPadding,
        right: AppValues.screenPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppValues.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.outline.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE5F6FD),
                ),
                alignment: Alignment.center,
                child: const Text('🧪', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: AppValues.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Báo Cáo Vi Chất Hôm Nay',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Giữ các chỉ số trong ngưỡng an toàn để bảo vệ sức khỏe',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                color: AppColors.onSurfaceVariant,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing20),

          // Micronutrients Rows
          _MicroCard(
            label: 'Natri (Sodium)',
            consumed: '${summary.totalSodiumMg.toInt()} mg',
            limit: 'Tối đa ${summary.targetSodiumMg.toInt()} mg',
            progress: summary.targetSodiumMg > 0
                ? (summary.totalSodiumMg / summary.targetSodiumMg).clamp(0.0, 1.0)
                : 0.0,
            badge: summary.totalSodiumMg > summary.targetSodiumMg
                ? 'VƯỢT MỨC'
                : 'AN TOÀN',
            isWarning: summary.totalSodiumMg > summary.targetSodiumMg,
            accentColor: AppColors.primary,
          ),
          const SizedBox(height: AppValues.spacing12),

          _MicroCard(
            label: 'Chất xơ (Fiber)',
            consumed: '${summary.totalFiberG.toStringAsFixed(1)} g',
            limit: 'Mục tiêu ${summary.targetFiberG.toInt()} g',
            progress: summary.targetFiberG > 0
                ? (summary.totalFiberG / summary.targetFiberG).clamp(0.0, 1.0)
                : 0.0,
            badge: summary.totalFiberG >= summary.targetFiberG
                ? 'ĐẠT'
                : '${(summary.totalFiberG / (summary.targetFiberG > 0 ? summary.targetFiberG : 1) * 100).toInt()}%',
            isWarning: false,
            accentColor: AppColors.brandGreen,
          ),
          const SizedBox(height: AppValues.spacing12),

          _MicroCard(
            label: 'Lượng đường (Sugar)',
            consumed: '${summary.totalSugarG.toStringAsFixed(1)} g',
            limit: 'Tối đa ${summary.targetSugarG.toInt()} g',
            progress: summary.targetSugarG > 0
                ? (summary.totalSugarG / summary.targetSugarG).clamp(0.0, 1.0)
                : 0.0,
            badge: summary.totalSugarG > summary.targetSugarG
                ? 'QUÁ NHIỀU'
                : 'ỔN ĐỊNH',
            isWarning: summary.totalSugarG > summary.targetSugarG,
            accentColor: AppColors.tertiary,
          ),
          const SizedBox(height: AppValues.spacing20),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ClayButton(
              text: 'Đã hiểu',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MicroCard extends StatelessWidget {
  const _MicroCard({
    required this.label,
    required this.consumed,
    required this.limit,
    required this.progress,
    required this.badge,
    required this.isWarning,
    required this.accentColor,
  });

  final String label;
  final String consumed;
  final String limit;
  final double progress;
  final String badge;
  final bool isWarning;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      elevation: 2.0,
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    consumed,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isWarning ? AppColors.error : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '($limit)',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isWarning
                          ? AppColors.error.withValues(alpha: 0.15)
                          : accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isWarning ? AppColors.error : accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFEDE9E1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isWarning ? AppColors.error : accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
