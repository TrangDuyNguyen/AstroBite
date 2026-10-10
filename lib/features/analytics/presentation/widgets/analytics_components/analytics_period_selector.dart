import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

/// Tactile Clay Period Selector for Analytics (7 days vs 30 days).
class AnalyticsPeriodSelector extends StatelessWidget {
  const AnalyticsPeriodSelector({
    super.key,
    required this.selectedDays,
    required this.onPeriodChanged,
  });

  final int selectedDays;
  final ValueChanged<int> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1EEE8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFDDD8CE),
            offset: Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: SegmentedButton<int>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: 7,
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(context.l10n.sevenDays),
            ),
          ),
          ButtonSegment(
            value: 30,
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(context.l10n.thirtyDays),
            ),
          ),
        ],
        selected: {selectedDays},
        onSelectionChanged: (set) => onPeriodChanged(set.first),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return AppColors.onSurfaceVariant;
          }),
          textStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 14,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w600,
            );
          }),
          elevation: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected) ? 2.0 : 0.0;
          }),
          side: const WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
