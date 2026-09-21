import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../../domain/streak_record.dart';

/// Modal bottom sheet displaying detailed streak analytics, shields, and celestial badges.
class StreakDetailSheet extends StatelessWidget {
  const StreakDetailSheet({
    super.key,
    required this.streak,
  });

  final StreakRecord streak;

  static void show(BuildContext context, StreakRecord streak) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StreakDetailSheet(streak: streak),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.spacing12,
        AppValues.screenPadding,
        AppValues.spacing32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Header
          Text(
            'Tiểu Vũ Trụ Dinh Dưỡng',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kỷ luật ăn sạch nuôi dưỡng năng lượng sinh học',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppValues.spacing20),

          // Big Streak & Shield Summary Card
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  icon: '🔥',
                  value: '${streak.currentStreak}',
                  label: 'Chuỗi Hiện Tại',
                  color: AppColors.tertiary,
                ),
                Container(width: 1, height: 48, color: AppColors.outline.withValues(alpha: 0.2)),
                _buildMetric(
                  icon: '⭐',
                  value: '${streak.longestStreak}',
                  label: 'Kỷ Lục Dài Nhất',
                  color: AppColors.primary,
                ),
                Container(width: 1, height: 48, color: AppColors.outline.withValues(alpha: 0.2)),
                _buildMetric(
                  icon: '🛡️',
                  value: '${streak.starlightShields}/2',
                  label: 'Khiên Tinh Tú',
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Starlight Shield Notice
          Container(
            padding: const EdgeInsets.all(AppValues.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppValues.cardRadius),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_moon_rounded,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(width: AppValues.spacing12),
                Expanded(
                  child: Text(
                    streak.hasShield
                        ? 'Khiên Tinh Tú đang bảo vệ chuỗi của bạn nếu lỡ quên log 1 ngày.'
                        : 'Hoàn thành chuỗi 7 ngày liên tiếp để nhận thêm 1 Khiên Tinh Tú!',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.spacing20),

          // Badges Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Huy Hiệu Vũ Trụ',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing12),

          // Badges Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppValues.spacing12,
              mainAxisSpacing: AppValues.spacing12,
              childAspectRatio: 2.1,
            ),
            itemCount: CosmicBadge.allBadges.length,
            itemBuilder: (context, index) {
              final badge = CosmicBadge.allBadges[index];
              final isUnlocked = streak.unlockedBadgeIds.contains(badge.id);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.surfaceContainer
                      : AppColors.surfaceContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppValues.radius8),
                  border: Border.all(
                    color: isUnlocked
                        ? AppColors.tertiary.withValues(alpha: 0.6)
                        : AppColors.outline.withValues(alpha: 0.15),
                    width: isUnlocked ? 1.0 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      badge.icon,
                      style: TextStyle(
                        fontSize: 24,
                        color: isUnlocked ? null : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badge.title,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isUnlocked
                                  ? AppColors.onSurface
                                  : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isUnlocked ? 'Đã Mở Khóa' : '${badge.requiredDays} ngày chuỗi',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
                              color: isUnlocked ? AppColors.tertiary : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildMetric({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
