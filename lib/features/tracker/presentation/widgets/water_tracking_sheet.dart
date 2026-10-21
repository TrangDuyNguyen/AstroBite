import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/entities/water_quick_preset.dart';
import '../../domain/tracker_providers.dart';
import '../controllers/water_controller.dart';

/// Modal bottom sheet for logging water intake and viewing today's history
class WaterTrackingSheet extends ConsumerStatefulWidget {
  const WaterTrackingSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WaterTrackingSheet(),
    );
  }

  @override
  ConsumerState<WaterTrackingSheet> createState() => _WaterTrackingSheetState();
}

class _WaterTrackingSheetState extends ConsumerState<WaterTrackingSheet> {
  int _selectedAmount = 250;

  @override
  Widget build(BuildContext context) {
    final waterLogAsync = ref.watch(dailyWaterStreamProvider);
    final waterLog = waterLogAsync.value ?? WaterDayLog.initial(date: 'today');

    return ClaySheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '💧 Ghi Nhận Nước Uống',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '${waterLog.currentMl} / ${waterLog.targetMl} ml',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          Row(
            children: [
              for (final preset in [
                WaterQuickPreset.glass250,
                WaterQuickPreset.bottle500,
                WaterQuickPreset.flask750,
              ]) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedAmount = preset.amountMl),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedAmount == preset.amountMl
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedAmount == preset.amountMl
                              ? AppColors.primary
                              : AppColors.outline,
                          width: _selectedAmount == preset.amountMl ? 1.8 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(preset.icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Text(
                            preset.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedAmount == preset.amountMl
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedAmount == preset.amountMl
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (preset != WaterQuickPreset.flask750)
                  const SizedBox(width: AppValues.spacing8),
              ],
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          Text(
            'Lượng uống: $_selectedAmount ml',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          Slider(
            value: _selectedAmount.toDouble(),
            min: 50,
            max: 1500,
            divisions: 29,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.outline,
            onChanged: (val) => setState(() => _selectedAmount = val.round()),
          ),
          const SizedBox(height: AppValues.spacing8),
          ClayButton(
            text: 'Thêm +$_selectedAmount ml',
            variant: ClayButtonVariant.primary,
            onPressed: () {
              ref.read(waterControllerProvider.notifier).addWater(_selectedAmount);
              Navigator.of(context).pop();
            },
          ),
          if (waterLog.entries.isNotEmpty) ...[
            const SizedBox(height: AppValues.spacing16),
            const Text(
              'Lịch sử hôm nay',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppValues.spacing8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 140),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: waterLog.entries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final entry = waterLog.entries[waterLog.entries.length - 1 - idx];
                  final timeStr =
                      '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Text('💧', style: TextStyle(fontSize: 18)),
                    title: Text(
                      '+${entry.amountMl} ml',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
