import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/scanner_providers.dart';

/// Top Quota Badge indicating the remaining free scans today.
class CameraQuotaBadge extends ConsumerWidget {
  const CameraQuotaBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanCountAsync = ref.watch(todayScanCountProvider);
    final count = scanCountAsync.valueOrNull ?? 0;
    final remaining = (AppValues.maxDailyScans - count).clamp(0, AppValues.maxDailyScans);
    final isOverLimit = count >= AppValues.maxDailyScans;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isOverLimit
            ? const Color(0xFFFFF1F2)
            : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(AppValues.spacing48),
        border: Border.all(
          color: isOverLimit
              ? const Color(0xFFFECDD3)
              : const Color(0xFFBBF7D0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1E2337),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isOverLimit
              ? const ClayMorphIcon(
                  icon: Icons.error_outline_rounded,
                  size: 15,
                  color: AppColors.error,
                )
              : const Clay3DStar(size: 15),
          const SizedBox(width: 6),
          Text(
            isOverLimit
                ? 'Đã hết lượt quét hôm nay (10/10)'
                : 'Còn lại $remaining/${AppValues.maxDailyScans} lượt quét hôm nay',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isOverLimit ? AppColors.error : const Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }
}
