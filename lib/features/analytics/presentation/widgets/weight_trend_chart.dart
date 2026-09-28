import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Claymorphic Weight Trend Line Chart with goal benchmark and tactile points.
class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({
    super.key,
    this.weights,
    this.targetWeight = 64.0,
    this.days = 7,
  });

  final List<double>? weights;
  final double targetWeight;
  final int days;

  @override
  Widget build(BuildContext context) {
    // Generate realistic data points if none provided
    final weightList = weights ??
        (days <= 7
            ? const [66.2, 66.0, 65.8, 65.5, 65.3, 65.1, 65.0]
            : const [
                67.5, 67.4, 67.2, 67.0, 66.9, 66.8, 66.7,
                66.6, 66.5, 66.3, 66.2, 66.2, 66.0, 65.9,
                65.8, 65.8, 65.7, 65.6, 65.5, 65.4, 65.4,
                65.3, 65.3, 65.2, 65.2, 65.1, 65.1, 65.0, 65.0, 65.0,
              ]);

    final spots = <FlSpot>[];
    double minVal = targetWeight;
    double maxVal = targetWeight;

    for (var i = 0; i < weightList.length; i++) {
      final w = weightList[i];
      if (w < minVal) minVal = w;
      if (w > maxVal) maxVal = w;
      spots.add(FlSpot(i.toDouble(), w));
    }

    final minY = (minVal - 0.6).floorToDouble();
    final maxY = (maxVal + 0.6).ceilToDouble();
    final double yInterval = (maxY - minY) > 4 ? 1.0 : 0.5;

    // Weekday labels for 7-day view
    const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return SizedBox(
      height: 220,
      child: RepaintBoundary(
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            minX: 0,
            maxX: max(0, weightList.length - 1).toDouble(),
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
                  y: targetWeight,
                  color: AppColors.brandGreen.withValues(alpha: 0.75),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 6, bottom: 3),
                    style: const TextStyle(
                      color: AppColors.brandGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                    labelResolver: (_) => 'Mục tiêu: ${targetWeight.toStringAsFixed(1)} kg',
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
                  reservedSize: 36,
                  interval: yInterval,
                  getTitlesWidget: (value, meta) {
                    if (value < minY || value > maxY) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        value.toStringAsFixed(1),
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
                  interval: (days <= 7) ? 1.0 : max(1.0, (weightList.length - 1) / 4),
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= weightList.length) {
                      return const SizedBox.shrink();
                    }

                    String label;
                    if (days <= 7) {
                      label = weekdays[index % weekdays.length];
                    } else {
                      final count = max(1, weightList.length - 1);
                      final ratio = index / count;
                      if (ratio <= 0.05) {
                        label = 'Tuần 1';
                      } else if ((ratio - 0.25).abs() < 0.09) {
                        label = 'Tuần 2';
                      } else if ((ratio - 0.50).abs() < 0.09) {
                        label = 'Tuần 3';
                      } else if ((ratio - 0.75).abs() < 0.09) {
                        label = 'Tuần 4';
                      } else if (ratio >= 0.94) {
                        label = 'Hôm nay';
                      } else {
                        return const SizedBox.shrink();
                      }
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
                      color: AppColors.secondary.withValues(alpha: 0.5),
                      strokeWidth: 1.5,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 6.0,
                        color: Colors.white,
                        strokeWidth: 3.5,
                        strokeColor: AppColors.secondary,
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
                    final dayNumber = spot.x.toInt() + 1;
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)} kg',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: days <= 7
                              ? ' (${weekdays[(dayNumber - 1) % weekdays.length]})'
                              : ' (Ngày $dayNumber)',
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
                barWidth: days <= 7 ? 3.5 : 2.8,
                isStrokeCapRound: true,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF7EAA),
                    AppColors.secondary,
                  ],
                ),
                dotData: FlDotData(
                  show: days <= 7,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4.5,
                    color: Colors.white,
                    strokeWidth: 3.0,
                    strokeColor: AppColors.secondary,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.22),
                      AppColors.secondary.withValues(alpha: 0.01),
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
