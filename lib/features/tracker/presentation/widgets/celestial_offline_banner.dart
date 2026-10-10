import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/tracker_providers.dart';
import '../controllers/tracker_controller.dart';

class CelestialOfflineBanner extends ConsumerWidget {
  const CelestialOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing16,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppValues.spacing8),
          Expanded(
            child: Text(
              context.l10n.offlineModeNotice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warning.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          InkWell(
            onTap: () async {
              final user = ref.read(authStateProvider).value;
              if (user != null) {
                final count = await ref
                    .read(trackerControllerProvider.notifier)
                    .syncPendingLogs(userId: user.uid);
                if (context.mounted && count > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.syncedMealsCount(count)),
                    ),
                  );
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.sync,
                size: 16,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
