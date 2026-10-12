import 'package:flutter/material.dart';
import '../../domain/daily_summary.dart';
import 'solar_orbital_cockpit.dart';

/// Adapter for DailySummaryCard, rendering the next-gen Solar Orbital Cockpit.
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    return SolarOrbitalCockpit(summary: summary);
  }
}
