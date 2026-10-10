import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/streak_record.dart';
import 'streak_badge_detail_dialog.dart';

/// Cosmic Badges Grid (2x2) and Badge Tile Component.
class StreakCosmicBadgeGrid extends StatelessWidget {
  const StreakCosmicBadgeGrid({
    super.key,
    required this.streak,
  });

  final StreakRecord streak;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Huy Hiệu Vũ Trụ',
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9D8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB4EAA0), width: 1.2),
              ),
              child: Text(
                '${streak.unlockedBadgeIds.length}/${CosmicBadge.allBadges.length} ĐÃ MỞ',
                style: GoogleFonts.outfit(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing12),

        // Badges Grid (2x2)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppValues.spacing12,
            mainAxisSpacing: AppValues.spacing12,
            childAspectRatio: 1.85,
          ),
          itemCount: CosmicBadge.allBadges.length,
          itemBuilder: (context, index) {
            final badge = CosmicBadge.allBadges[index];
            final isUnlocked = streak.unlockedBadgeIds.contains(badge.id);
            return _buildBadgeTile(context, badge, isUnlocked);
          },
        ),
      ],
    );
  }

  Widget _buildBadgeTile(BuildContext context, CosmicBadge badge, bool isUnlocked) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => StreakBadgeDetailDialog.show(context, badge, isUnlocked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surfaceContainer : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? const Color(0xFFFFD54F) : const Color(0xFFE5E7EB),
            width: isUnlocked ? 1.4 : 1.0,
          ),
          boxShadow: isUnlocked
              ? const [
                  BoxShadow(
                    color: Color(0x30FFA000),
                    offset: Offset(0, 3),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x12FFA000),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: Row(
          children: [
            // Badge Avatar Disc
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? StreakBadgeDetailDialog.badgeBgColor(badge.id)
                    : const Color(0xFFE5E7EB),
                border: Border.all(
                  color: isUnlocked ? Colors.white : const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
                boxShadow: isUnlocked
                    ? const [
                        BoxShadow(
                          color: Color(0x18000000),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isUnlocked
                    ? _buildBadgeIcon(badge)
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 0.35,
                            child: Text(
                              badge.icon,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const Icon(
                            Icons.lock_rounded,
                            size: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(width: 8),

            // Badge Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badge.title,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isUnlocked ? AppColors.onSurface : const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  if (isUnlocked)
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: AppColors.brandGreen,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Đã Mở Khóa',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandGreen,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '${badge.requiredDays} ngày chuỗi',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(CosmicBadge badge) {
    if (badge.id == CosmicBadge.starlightNovice.id) {
      return const Clay3DStar(size: 20);
    }
    return Text(
      badge.icon,
      style: const TextStyle(fontSize: 20),
    );
  }
}
