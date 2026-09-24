import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Celestial time phases throughout the 24-hour cycle.
enum CelestialTimePhase {
  lateNight, // 00:00 - 04:59: Trăng khuyết đêm khuya
  dawn,      // 05:00 - 10:59: Bình minh hé rạng
  daylight,  // 11:00 - 16:59: Mặt trời năng lượng ban ngày
  twilight,  // 17:00 - 20:59: Hoàng hôn chuyển giao
  night,     // 21:00 - 23:59: Đêm trăng ngàn sao
}

/// Dynamic Celestial Avatar for the Top AppBar.
/// Shows a gradient cosmic ring with an inner icon that morphs
/// between moon phases and sun stages according to the current hour.
class CelestialTimeAvatar extends StatelessWidget {
  const CelestialTimeAvatar({
    super.key,
    this.time,
    this.onTap,
  });

  final DateTime? time;
  final VoidCallback? onTap;

  static CelestialTimePhase getPhase(int hour) {
    if (hour >= 0 && hour < 5) return CelestialTimePhase.lateNight;
    if (hour >= 5 && hour < 11) return CelestialTimePhase.dawn;
    if (hour >= 11 && hour < 17) return CelestialTimePhase.daylight;
    if (hour >= 17 && hour < 21) return CelestialTimePhase.twilight;
    return CelestialTimePhase.night;
  }

  @override
  Widget build(BuildContext context) {
    final currentHour = (time ?? DateTime.now()).hour;
    final phase = getPhase(currentHour);

    final (iconData, iconColor, dotColor, tooltip) = switch (phase) {
      CelestialTimePhase.lateNight => (
        Icons.nightlight_round,
        AppColors.primary,
        const Color(0xFF80D8FF),
        'Đêm khuya thanh tịnh',
      ),
      CelestialTimePhase.dawn => (
        Icons.wb_twilight,
        AppColors.tertiary,
        AppColors.tertiary,
        'Bình minh ngập tràn năng lượng',
      ),
      CelestialTimePhase.daylight => (
        Icons.wb_sunny_rounded,
        const Color(0xFFFFB300),
        AppColors.primary,
        'Ban ngày rực rỡ',
      ),
      CelestialTimePhase.twilight => (
        Icons.wb_twilight_rounded,
        AppColors.secondary,
        AppColors.secondary,
        'Hoàng hôn buông xuống',
      ),
      CelestialTimePhase.night => (
        Icons.nights_stay,
        AppColors.primary,
        AppColors.tertiary,
        'Đêm trăng ngàn sao',
      ),
    };

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Outer Cosmic Gradient Border Ring
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.tertiary,
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            // Little Celestial Orbit Indicator at bottom-right
            Positioned(
              bottom: -0.5,
              right: -0.5,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
