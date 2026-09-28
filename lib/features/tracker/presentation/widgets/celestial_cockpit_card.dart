import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/daily_summary.dart';

/// The signature Glanceable Celestial Cockpit Card.
/// Unifies Calorie Progress Arc and 3 Macro indicators side-by-side into a single compact card,
/// with an integrated collapsible micronutrient drawer.
class CelestialCockpitCard extends StatefulWidget {
  const CelestialCockpitCard({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  State<CelestialCockpitCard> createState() => _CelestialCockpitCardState();
}

class _CelestialCockpitCardState extends State<CelestialCockpitCard> {
  bool _isMicrosExpanded = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final isOverBudget = summary.totalCalories > summary.targetCalories;

    return ClayCard(
      borderRadius: 24,
      borderColor: isOverBudget
          ? AppColors.tertiary
          : const Color(0xFFEDE9E1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Cockpit Badge & Calorie Target
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE5F6FD),
                      border: Border.all(
                        color: const Color(0xFFBCE3F7),
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBCE3F7),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x181CB0F6),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Clay3DRocket(size: 18),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Text(
                    'CELESTIAL COCKPIT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                  ),
                ],
              ),
              Text(
                'Mục tiêu: ${summary.targetCalories} kcal',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),

          // Main Cockpit Row: Left Calorie Arc & Right 3 Macro Bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Calorie Radial Arc
              CalorieProgressArc(
                consumed: summary.totalCalories,
                target: summary.targetCalories,
                size: 130,
                strokeWidth: 10,
              ),
              const SizedBox(width: AppValues.spacing16),

              // Right: 3 Macro Bars (Carbs, Protein, Fat)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MacroBar(
                      label: AppStrings.carbs,
                      currentG: summary.totalCarbsG,
                      targetG: summary.targetCarbsG,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    MacroBar(
                      label: AppStrings.protein,
                      currentG: summary.totalProteinG,
                      targetG: summary.targetProteinG,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    MacroBar(
                      label: AppStrings.fat,
                      currentG: summary.totalFatG,
                      targetG: summary.targetFatG,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),
          const Divider(height: 1, color: Color(0xFFEDE9E1)),
          const SizedBox(height: AppValues.spacing8),

          // Collapsible Micronutrients Pill / Button (Clay 3D Capsule)
          InkWell(
            onTap: () => setState(() => _isMicrosExpanded = !_isMicrosExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F5EE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE8E3D7),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 3D Flask inside soft clay badge
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppValues.radius8),
                      border: Border.all(
                        color: const Color(0xFFEDE8DD),
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          offset: Offset(0, 1.5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Clay3DFlask(size: 18),
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Expanded(
                    child: Text(
                      'Vi chất: Natri ${summary.totalSodiumMg.toInt()}mg • Xơ ${summary.totalFiberG.toInt()}g • Đường ${summary.totalSugarG.toInt()}g',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing4),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEDE8DD),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      _isMicrosExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 15,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Micronutrient details
          if (_isMicrosExpanded)
            Padding(
              padding: const EdgeInsets.only(top: AppValues.spacing8),
              child: Column(
                children: [
                  _MicroNutrientRow(
                    label: 'Natri (Sodium)',
                    current: '${summary.totalSodiumMg.toInt()} mg',
                    limit: 'Tối đa ${summary.targetSodiumMg.toInt()} mg',
                    isWarning: summary.totalSodiumMg > summary.targetSodiumMg,
                    accentColor: summary.totalSodiumMg > summary.targetSodiumMg
                        ? AppColors.error
                        : const Color(0xFF00B0FF),
                    icon: Clay3DSaltShaker(
                      size: 20,
                      accentColor: summary.totalSodiumMg > summary.targetSodiumMg
                          ? AppColors.error
                          : const Color(0xFF00B0FF),
                    ),
                    currentVal: summary.totalSodiumMg,
                    targetVal: summary.targetSodiumMg,
                    statusBadgeText: summary.totalSodiumMg > summary.targetSodiumMg
                        ? 'VƯỢT MỨC'
                        : 'AN TOÀN',
                  ),
                  const SizedBox(height: AppValues.spacing8),
                  _MicroNutrientRow(
                    label: 'Chất xơ (Fiber)',
                    current: '${summary.totalFiberG.toInt()} g',
                    limit: 'Mục tiêu ${summary.targetFiberG.toInt()} g',
                    isWarning: false,
                    accentColor: const Color(0xFF58CC02),
                    icon: const Clay3DSprout(size: 20, accentColor: Color(0xFF58CC02)),
                    currentVal: summary.totalFiberG,
                    targetVal: summary.targetFiberG,
                    statusBadgeText: summary.totalFiberG >= summary.targetFiberG
                        ? 'ĐẠT MỤC TIÊU'
                        : '${summary.targetFiberG > 0 ? (summary.totalFiberG / summary.targetFiberG * 100).toInt() : 0}%',
                  ),
                  const SizedBox(height: AppValues.spacing8),
                  _MicroNutrientRow(
                    label: 'Lượng đường (Sugar)',
                    current: '${summary.totalSugarG.toInt()} g',
                    limit: 'Tối đa ${summary.targetSugarG.toInt()} g',
                    isWarning: summary.totalSugarG > summary.targetSugarG,
                    accentColor: summary.totalSugarG > summary.targetSugarG
                        ? AppColors.error
                        : const Color(0xFFFF9600),
                    icon: Clay3DSugarCube(
                      size: 20,
                      accentColor: summary.totalSugarG > summary.targetSugarG
                          ? AppColors.error
                          : const Color(0xFFFF9600),
                    ),
                    currentVal: summary.totalSugarG,
                    targetVal: summary.targetSugarG,
                    statusBadgeText: summary.totalSugarG > summary.targetSugarG
                        ? 'VƯỢT MỨC'
                        : 'ỔN ĐỊNH',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MicroNutrientRow extends StatelessWidget {
  const _MicroNutrientRow({
    required this.label,
    required this.current,
    required this.limit,
    required this.isWarning,
    required this.accentColor,
    this.icon,
    this.currentVal = 0,
    this.targetVal = 1,
    this.statusBadgeText,
  });

  final String label;
  final String current;
  final String limit;
  final bool isWarning;
  final Color accentColor;
  final Widget? icon;
  final double currentVal;
  final double targetVal;
  final String? statusBadgeText;

  @override
  Widget build(BuildContext context) {
    final progress = targetVal > 0 ? (currentVal / targetVal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(
          color: isWarning ? AppColors.error : const Color(0xFFEDE8DD),
          width: isWarning ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isWarning
                ? const Color(0x28FF4B4B)
                : const Color(0x12000000),
            offset: const Offset(0, 2.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppValues.spacing8),
                  ] else ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    current,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isWarning ? AppColors.error : AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '($limit)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                  ),
                  if (statusBadgeText != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isWarning ? AppColors.error : accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppValues.radius8),
                        border: Border.all(
                          color: isWarning ? AppColors.error : accentColor.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        statusBadgeText!,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isWarning ? Colors.white : accentColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Chunky Mini Clay Progress Bar
          Container(
            height: 6.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEBE7DF), // neutral clay track grey
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(
                color: const Color(0xFFDDD8CE),
                width: 0.8,
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(accentColor, Colors.white, 0.3)!,
                      accentColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(accentColor, Colors.black, 0.3)!,
                      offset: const Offset(0, 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
