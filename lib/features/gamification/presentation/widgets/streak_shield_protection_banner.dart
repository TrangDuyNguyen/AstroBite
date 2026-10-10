import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/streak_record.dart';

/// Starlight Shield Interactive Protection Banner with 7-day progress milestone.
class StreakShieldProtectionBanner extends StatelessWidget {
  const StreakShieldProtectionBanner({
    super.key,
    required this.streak,
  });

  final StreakRecord streak;

  @override
  Widget build(BuildContext context) {
    final cycleProgress = streak.currentStreak % 7;
    final daysLeft = 7 - (cycleProgress == 0 && streak.currentStreak > 0 ? 7 : cycleProgress);
    final progressRatio = (cycleProgress == 0 && streak.currentStreak > 0) ? 1.0 : cycleProgress / 7.0;

    final isProtected = streak.hasShield;
    final primaryBg = isProtected ? const Color(0xFFF0F9FF) : const Color(0xFFFFF2F5);
    final borderCol = isProtected ? const Color(0xFFBAE6FD) : const Color(0xFFFFCCD5);
    final bevelCol = isProtected ? const Color(0xFF7DD3FC) : const Color(0xFFFDA4AF);

    return Container(
      padding: const EdgeInsets.all(AppValues.spacing16),
      decoration: BoxDecoration(
        color: primaryBg,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isProtected
              ? [const Color(0xFFF5FAFF), const Color(0xFFE5F4FD)]
              : [const Color(0xFFFFF6F8), const Color(0xFFFFEDF2)],
        ),
        borderRadius: BorderRadius.circular(AppValues.cardRadius),
        border: Border.all(color: borderCol, width: 1.4),
        boxShadow: [
          // 3D bottom bevel
          BoxShadow(
            color: bevelCol.withValues(alpha: 0.8),
            offset: const Offset(0, 3.5),
            blurRadius: 0,
          ),
          // Ambient soft glow
          BoxShadow(
            color: (isProtected ? const Color(0xFF38BDF8) : const Color(0xFFFF5C8D)).withValues(alpha: 0.12),
            offset: const Offset(0, 5),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Clay3DShield(
                size: 32,
                isActive: isProtected,
              ),
              const SizedBox(width: AppValues.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isProtected ? 'Khiên Tinh Tú Đang Bật' : 'Tích Lũy Khiên Tinh Tú',
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isProtected ? const Color(0xFFE0F2FE) : const Color(0xFFFFE4E6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderCol, width: 0.8),
                          ),
                          child: Text(
                            isProtected ? 'BẢO VỆ' : 'MỐC 7 NGÀY',
                            style: GoogleFonts.outfit(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: isProtected ? const Color(0xFF0284C7) : const Color(0xFFE11D48),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      streak.hasShield
                          ? 'Khiên Tinh Tú đang bảo vệ chuỗi của bạn nếu lỡ quên log 1 ngày.'
                          : 'Hoàn thành chuỗi 7 ngày liên tiếp để nhận thêm 1 Khiên Tinh Tú!',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Milestone Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 7,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progressRatio.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isProtected
                                  ? [const Color(0xFF38BDF8), const Color(0xFF0284C7)]
                                  : [const Color(0xFFFF8DA1), const Color(0xFFFF5C8D)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                daysLeft == 0 && streak.currentStreak > 0
                    ? 'Đã đạt mốc khiên! 🎉'
                    : 'Còn $daysLeft ngày chuỗi',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isProtected ? const Color(0xFF0284C7) : const Color(0xFFE11D48),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
