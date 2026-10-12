import 'package:flutter/material.dart';
import 'galactic_date_orbit.dart';

/// Horizontal 7-day strip selector for quick date navigation.
/// Now delegates to the next-gen GalacticDateOrbit with 3D volumetric planets.
class DatePickerStrip extends StatelessWidget {
  const DatePickerStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return const GalacticDateOrbit();
  }
}
