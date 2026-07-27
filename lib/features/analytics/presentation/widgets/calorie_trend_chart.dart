import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CalorieTrendChart extends StatelessWidget {
  const CalorieTrendChart({
    super.key,
    required this.dailyTotals,
    this.targetCalories = 2000,
  });

  final Map<String, int> dailyTotals;
  final int targetCalories;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final entries = dailyTotals.entries.toList();

    if (entries.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Chưa có dữ liệu theo dõi')),
      );
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < entries.length; i++) {
      spots.add(FlSpot(i.toDouble(), entries[i].value.toDouble()));
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outline.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
