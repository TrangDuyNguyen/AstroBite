import 'package:flutter/material.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'cockpit_micronutrient_row.dart';

/// Collapsible Micronutrients Drawer for CelestialCockpitCard.
class CockpitMicronutrientsDrawer extends StatelessWidget {
  final DailySummary summary;
  final bool isExpanded;
  final VoidCallback onToggle;

  const CockpitMicronutrientsDrawer({
    super.key,
    required this.summary,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Collapsible Micronutrients Pill / Button (Clay 3D Capsule)
        InkWell(
          onTap: onToggle,
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
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 15,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expanded Micronutrient details
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: AppValues.spacing8),
            child: Column(
              children: [
                CockpitMicronutrientRow(
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
                CockpitMicronutrientRow(
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
                CockpitMicronutrientRow(
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
    );
  }
}
