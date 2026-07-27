import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Temporary placeholder screens for router compilation.
/// Each will be replaced by actual feature screens.

@RoutePage()
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Analytics')),
  );
}

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Profile')),
  );
}

@RoutePage()
class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Profile Edit')),
  );
}
