import 'package:flutter/material.dart';
import '../../domain/daily_summary.dart';
import 'celestial_cockpit_card.dart';

/// Legacy adapter for DailySummaryCard, now rendering the Glanceable Celestial Cockpit.
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    return CelestialCockpitCard(summary: summary);
  }
}
