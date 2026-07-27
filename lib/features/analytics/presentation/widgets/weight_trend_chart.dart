import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Demo weight points
    final spots = const [
      FlSpot(0, 66.2),
      FlSpot(1, 66.0),
      FlSpot(2, 65.8),
      FlSpot(3, 65.5),
      FlSpot(4, 65.3),
      FlSpot(5, 65.1),
      FlSpot(6, 65.0),
    ];

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
              color: colorScheme.secondary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.secondary.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
