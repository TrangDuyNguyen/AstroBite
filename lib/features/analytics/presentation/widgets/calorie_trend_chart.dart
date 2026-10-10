import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

/// Claymorphic Calorie Trend Line Chart with goal benchmark and tactile points.
class CalorieTrendChart extends StatelessWidget {
  const CalorieTrendChart({
    super.key,
    required this.dailyTotals,
    this.targetCalories = 2000,
    this.days = 7,
  });

  final Map<String, int> dailyTotals;
  final int targetCalories;
  final int days;

  @override
  Widget build(BuildContext context) {
    final entries = dailyTotals.entries.toList();

    if (entries.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.clayLunch,
                shape: BoxShape.circle,
              ),
              child: const Text('📊', style: TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 10),
            Text(
              context.l10n.noTrackingData,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Sort entries chronologically
    final sortedEntries = entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    final spots = <FlSpot>[];
    double maxVal = targetCalories.toDouble();
    for (var i = 0; i < sortedEntries.length; i++) {
      final val = sortedEntries[i].value.toDouble();
      if (val > maxVal) maxVal = val;
      spots.add(FlSpot(i.toDouble(), val));
    }

    final maxY = ((maxVal * 1.15) / 500).ceil() * 500.0;
    const minY = 0.0;
    final yInterval = maxY > 2500 ? 1000.0 : 500.0;

    return SizedBox(
      height: 220,
      child: RepaintBoundary(
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            minX: 0,
            maxX: max(0, sortedEntries.length - 1).toDouble(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: yInterval,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: Color(0xFFF0EFEB),
                strokeWidth: 1,
              ),
            ),
            extraLinesData: ExtraLinesData(
              extraLinesOnTop: false,
              horizontalLines: [
                HorizontalLine(
                  y: targetCalories.toDouble(),
                  color: AppColors.tertiary.withValues(alpha: 0.65),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 6, bottom: 3),
                    style: const TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                    labelResolver: (_) => context.l10n.chartTarget(targetCalories),
                  ),
                ),
              ],
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  interval: yInterval,
                  getTitlesWidget: (value, meta) {
                    if (value <= 0 || value > maxY) return const SizedBox.shrink();
                    String text;
                    if (value >= 1000) {
                      final k = value / 1000;
                      text = k == k.roundToDouble() ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
                    } else {
                      text = '${value.toInt()}';
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        text,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: (days <= 7) ? 1.0 : max(1.0, (sortedEntries.length - 1) / 4),
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= sortedEntries.length) {
                      return const SizedBox.shrink();
                    }

                    // For 30 days with many entries, only display ~5 milestone points
                    if (days > 7 && sortedEntries.length > 7) {
                      final count = sortedEntries.length - 1;
                      final ratio = count > 0 ? (index / count) : 0.0;
                      final isMilestone = ratio <= 0.05 ||
                          (ratio - 0.25).abs() < 0.09 ||
                          (ratio - 0.50).abs() < 0.09 ||
                          (ratio - 0.75).abs() < 0.09 ||
                          ratio >= 0.94;
                      if (!isMilestone) return const SizedBox.shrink();
                    }

                    final dateStr = sortedEntries[index].key;
                    final date = DateTime.tryParse(dateStr);
                    String label;
                    if (date != null) {
                      if (days <= 7) {
                        const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                        label = weekdays[(date.weekday - 1) % 7];
                      } else {
                        label = '${date.day}/${date.month}';
                      }
                    } else {
                      label = '${index + 1}';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      strokeWidth: 1.5,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 6.0,
                        color: Colors.white,
                        strokeWidth: 3.5,
                        strokeColor: AppColors.primary,
                      ),
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.onSurface.withValues(alpha: 0.92),
                tooltipRoundedRadius: 10,
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final dateStr = (index >= 0 && index < sortedEntries.length)
                        ? sortedEntries[index].key
                        : '';
                    final date = DateTime.tryParse(dateStr);
                    final dateLabel = date != null ? '${date.day}/${date.month}' : '';
                    return LineTooltipItem(
                      '${spot.y.round()} kcal',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        if (dateLabel.isNotEmpty)
                          TextSpan(
                            text: ' ($dateLabel)',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                barWidth: (days <= 7 && sortedEntries.length <= 10) ? 3.5 : 2.8,
                isStrokeCapRound: true,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF38BDF8),
                    AppColors.primary,
                  ],
                ),
                dotData: FlDotData(
                  show: days <= 7 && sortedEntries.length <= 10,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4.5,
                    color: Colors.white,
                    strokeWidth: 3.0,
                    strokeColor: AppColors.primary,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.28),
                      AppColors.primary.withValues(alpha: 0.01),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
