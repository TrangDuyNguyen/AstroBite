import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/streak_record.dart';

/// Modal dialog showing details and requirements of a selected Cosmic Badge.
class StreakBadgeDetailDialog extends StatelessWidget {
  const StreakBadgeDetailDialog({
    super.key,
    required this.badge,
    required this.isUnlocked,
  });

  final CosmicBadge badge;
  final bool isUnlocked;

  static void show(BuildContext context, CosmicBadge badge, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (_) => StreakBadgeDetailDialog(badge: badge, isUnlocked: isUnlocked),
    );
  }

  static Color badgeBgColor(String id) {
    switch (id) {
      case 'starlight_novice':
        return const Color(0xFFFFF9C4);
      case 'pulsar_pioneer':
        return const Color(0xFFEDE7F6);
      case 'protein_hunter':
        return const Color(0xFFFFF3E0);
      case 'supernova_titan':
        return const Color(0xFFE0F7FA);
      default:
        return const Color(0xFFFFF8E1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClayCard(
        padding: const EdgeInsets.all(AppValues.spacing20),
        borderRadius: 24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? badgeBgColor(badge.id) : const Color(0xFFE5E7EB),
                border: Border.all(
                  color: isUnlocked ? Colors.white : const Color(0xFFD1D5DB),
                  width: 2.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: isUnlocked
                    ? (badge.id == CosmicBadge.starlightNovice.id
                        ? const Clay3DStar(size: 34)
                        : Text(badge.icon, style: const TextStyle(fontSize: 32)))
                    : const Icon(Icons.lock_rounded, size: 28, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(height: AppValues.spacing16),
            Text(
              badge.title,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isUnlocked ? const Color(0xFFE8F9D8) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isUnlocked ? const Color(0xFFB4EAA0) : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                isUnlocked ? 'ĐÃ ĐẠT ĐƯỢC' : 'YÊU CẦU: ${badge.requiredDays} NGÀY CHUỖI',
                style: GoogleFonts.outfit(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: isUnlocked ? const Color(0xFF2E7D32) : const Color(0xFF6B7280),
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing12),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppValues.spacing20),
            ClayButton(
              text: 'Đã Hiểu',
              width: 140,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
