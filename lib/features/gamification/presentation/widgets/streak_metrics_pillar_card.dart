import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/streak_record.dart';

/// 3-Pillar Gamification Metrics Card (Current Streak, Longest Streak, Starlight Shields).
class StreakMetricsPillarCard extends StatelessWidget {
  const StreakMetricsPillarCard({
    super.key,
    required this.streak,
  });

  final StreakRecord streak;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      borderRadius: 22,
      child: Row(
        children: [
          // Column 1: Current Streak
          Expanded(
            child: _buildMetricTile(
              iconWidget: Stack(
                alignment: Alignment.center,
                children: [
                  const Opacity(
                    opacity: 0.0,
                    child: Text('🔥', style: TextStyle(fontSize: 0)),
                  ),
                  const Clay3DFlame(size: 26),
                ],
              ),
              value: '${streak.currentStreak}',
              label: 'Chuỗi Hiện Tại',
              color: AppColors.tertiary,
              bgColor: const Color(0xFFFFF9ED),
              borderColor: const Color(0xFFFFE7BA),
              tagText: streak.hasActiveStreak ? 'Đang cháy 🔥' : 'Bắt đầu',
              tagColor: const Color(0xFFB26A00),
            ),
          ),
          const SizedBox(width: 6),

          // Column 2: Longest Streak Record
          Expanded(
            child: _buildMetricTile(
              iconWidget: Stack(
                alignment: Alignment.center,
                children: [
                  const Opacity(
                    opacity: 0.0,
                    child: Text('⭐', style: TextStyle(fontSize: 0)),
                  ),
                  const Clay3DStar(size: 26),
                ],
              ),
              value: '${streak.longestStreak}',
              label: 'Kỷ Lục Dài Nhất',
              color: AppColors.primary,
              bgColor: const Color(0xFFF0F9FF),
              borderColor: const Color(0xFFBAE6FD),
              tagText: 'Mục tiêu',
              tagColor: const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(width: 6),

          // Column 3: Starlight Shields
          Expanded(
            child: _buildMetricTile(
              iconWidget: Stack(
                alignment: Alignment.center,
                children: [
                  const Opacity(
                    opacity: 0.0,
                    child: Text('🛡️', style: TextStyle(fontSize: 0)),
                  ),
                  Clay3DShield(
                    size: 26,
                    isActive: streak.hasShield,
                  ),
                ],
              ),
              value: '${streak.starlightShields}/2',
              label: 'Khiên Tinh Tú',
              color: AppColors.secondary,
              bgColor: const Color(0xFFFFF1F5),
              borderColor: const Color(0xFFFECDD3),
              tagText: streak.hasShield ? 'Đang bảo vệ' : 'Cần nạp',
              tagColor: const Color(0xFFBE123C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required Widget iconWidget,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required String tagText,
    required Color tagColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 28, child: Center(child: iconWidget)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Text(
              tagText,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: tagColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
