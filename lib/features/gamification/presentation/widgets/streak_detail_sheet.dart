import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/streak_record.dart';
import 'streak_cosmic_badge_grid.dart';
import 'streak_metrics_pillar_card.dart';
import 'streak_shield_protection_banner.dart';

/// Modal bottom sheet displaying detailed streak analytics, shields, and celestial badges
/// styled in signature Claymorphic × Duolingo 2D/3D (Solar Fresh) aesthetic.
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
        color: AppColors.surface, // Warm milk canvas
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.outline, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F1E2337),
            offset: Offset(0, -6),
            blurRadius: 24,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.spacing12,
        AppValues.screenPadding,
        MediaQuery.of(context).viewInsets.bottom + AppValues.spacing32,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Tactile Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: AppValues.spacing16),

              // 2. Micro Category Pill
              _buildCategoryPill(),
              const SizedBox(height: 8),

              // 3. Header Title & Subtitle
              Text(
                'Tiểu Vũ Trụ Dinh Dưỡng',
                style: GoogleFonts.outfit(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kỷ luật ăn sạch nuôi dưỡng năng lượng sinh học',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppValues.spacing20),

              // 4. 3-Pillar Gamification Metrics Card
              StreakMetricsPillarCard(streak: streak),
              const SizedBox(height: AppValues.spacing16),

              // 5. Starlight Shield Interactive Protection Banner
              StreakShieldProtectionBanner(streak: streak),
              const SizedBox(height: AppValues.spacing20),

              // 6 & 7. Badges Header & Grid
              StreakCosmicBadgeGrid(streak: streak),
              const SizedBox(height: AppValues.spacing20),

              // 8. AstroBot Encouragement Note
              _buildEncouragementNote(),
              const SizedBox(height: AppValues.spacing16),

              // 9. Leaderboard Button
              ClayButton(
                text: '🏆 Bảng Xếp Hạng Bạn Bè',
                variant: ClayButtonVariant.primary,
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.router.push(const LeaderboardRoute());
                },
              ),
              const SizedBox(height: AppValues.spacing12),

              // 10. Primary Action Button
              ClayButton(
                text: 'Tiếp Tục Kỷ Luật',
                width: double.infinity,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDF88), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14FF9600),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✨', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(
            'TIỂU VŨ TRỤ KỶ LUẬT',
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFB26A00),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragementNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.8), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1E2337),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const Clay3DAstroBot(size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mỗi ngày ăn đúng mục tiêu là một tinh cầu dinh dưỡng được thắp sáng rực rỡ! 🚀',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
