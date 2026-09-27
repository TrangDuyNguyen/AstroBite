import 'package:flutter/widgets.dart';
import 'package:solar_icons/solar_icons.dart';

/// Centralized Design System Icon Tokens for AstroBite.
/// Backed by Solar Icons (Bold & Outline) for a cohesive Celestial aesthetic.
abstract final class AppIcons {
  // Navigation / Tabs (ClayBottomNav)
  static const IconData navToday = SolarIconsOutline.calendar;
  static const IconData navTodaySelected = SolarIconsBold.calendar;

  static const IconData navCoach = SolarIconsOutline.magicStick;
  static const IconData navCoachSelected = SolarIconsBold.magicStick;

  static const IconData navCamera = SolarIconsBold.camera;

  static const IconData navAnalytics = SolarIconsOutline.chartSquare;
  static const IconData navAnalyticsSelected = SolarIconsBold.chartSquare;

  static const IconData navProfile = SolarIconsOutline.user;
  static const IconData navProfileSelected = SolarIconsBold.user;

  // Top AppBar & Quick Actions
  static const IconData book = SolarIconsBold.book;
  static const IconData bookOutline = SolarIconsOutline.book;
  static const IconData arrowDown = SolarIconsOutline.altArrowDown;
  static const IconData arrowDownSolid = SolarIconsBold.altArrowDown;

  // Gamification & Streak
  static const IconData shield = SolarIconsBold.shield;
  static const IconData shieldOutline = SolarIconsOutline.shield;
  static const IconData fire = SolarIconsBold.fire;
}
