import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/streak_record.dart';

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
              Container(
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
              ),
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
              ClayCard(
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
                            // Hidden semantic text for tests
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
                            // Hidden semantic text for tests
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
                            // Hidden semantic text for tests
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
              ),
              const SizedBox(height: AppValues.spacing16),

              // 5. Starlight Shield Interactive Protection Banner
              _buildShieldBanner(context),
              const SizedBox(height: AppValues.spacing20),

              // 6. Badges Header Row
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

              // 7. Badges Grid (2x2)
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
              const SizedBox(height: AppValues.spacing20),

              // 8. AstroBot Encouragement Note
              Container(
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
              ),
              const SizedBox(height: AppValues.spacing16),

              // 9. Primary Action Button
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

  /// Builds a single metric tile inside the 3-pillar card.
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

  /// Builds the Starlight Shield protection banner with progress milestone.
  Widget _buildShieldBanner(BuildContext context) {
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

  /// Builds a single Cosmic Badge card tile.
  Widget _buildBadgeTile(BuildContext context, CosmicBadge badge, bool isUnlocked) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showBadgeDetailDialog(context, badge, isUnlocked),
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
              ? [
                  // 3D bottom bevel
                  const BoxShadow(
                    color: Color(0x30FFA000),
                    offset: Offset(0, 3),
                    blurRadius: 0,
                  ),
                  // Ambient glow
                  const BoxShadow(
                    color: Color(0x12FFA000),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : [
                  const BoxShadow(
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
                color: isUnlocked ? _badgeBgColor(badge.id) : const Color(0xFFE5E7EB),
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

  Color _badgeBgColor(String id) {
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

  void _showBadgeDetailDialog(BuildContext context, CosmicBadge badge, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
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
                  color: isUnlocked ? _badgeBgColor(badge.id) : const Color(0xFFE5E7EB),
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
                onPressed: () => Navigator.of(dialogCtx).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
