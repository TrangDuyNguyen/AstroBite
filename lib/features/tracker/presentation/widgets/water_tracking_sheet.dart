import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/entities/water_quick_preset.dart';
import '../../domain/tracker_providers.dart';
import '../controllers/water_controller.dart';
import 'water_sheet_components.dart';

/// Puffy Claymorphic Bottom Sheet for Water Intake Quick Logging & History
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

  void _stepAmount(int delta) {
    setState(() {
      _selectedAmount = (_selectedAmount + delta).clamp(50, 1500);
    });
  }

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
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F6FD),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCDECFB), width: 1.2),
                      boxShadow: const [
                        BoxShadow(color: Color(0xFFB8E2FA), offset: Offset(0, 2)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text('💧', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  const Text(
                    'Ghi Nhận Nước Uống',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.clayLunch,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCDECFB), width: 1.2),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFFBCE1F5), offset: Offset(0, 2)),
                  ],
                ),
                child: Text(
                  '${waterLog.currentMl} / ${waterLog.targetMl} ml',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          // 3D Puffy Clay Presets
          Row(
            children: [
              for (final preset in [
                WaterQuickPreset.glass250,
                WaterQuickPreset.bottle500,
                WaterQuickPreset.flask750,
              ]) ...[
                Expanded(
                  child: ClayPresetCard(
                    preset: preset,
                    isSelected: _selectedAmount == preset.amountMl,
                    onTap: () => setState(() => _selectedAmount = preset.amountMl),
                  ),
                ),
                if (preset != WaterQuickPreset.flask750)
                  const SizedBox(width: AppValues.spacing8),
              ],
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          // Stepper row with quick buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MiniClayStepButton(icon: '−50', onTap: () => _stepAmount(-50)),
              const SizedBox(width: AppValues.spacing16),
              Text(
                '$_selectedAmount ml',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: AppValues.spacing16),
              MiniClayStepButton(icon: '+50', onTap: () => _stepAmount(50)),
            ],
          ),
          const SizedBox(height: AppValues.spacing8),
          // Custom Clay Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 10.0,
              trackShape: const RoundedRectSliderTrackShape(),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: const Color(0xFFEDE9E1),
              thumbShape: const ClaySliderThumbShape(thumbRadius: 13.0),
              overlayColor: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: _selectedAmount.toDouble(),
              min: 50,
              max: 1500,
              divisions: 29,
              onChanged: (val) => setState(() => _selectedAmount = val.round()),
            ),
          ),
          const SizedBox(height: AppValues.spacing12),
          ClayButton(
            text: 'Thêm +$_selectedAmount ml',
            variant: ClayButtonVariant.primary,
            height: 52,
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
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppValues.spacing8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: waterLog.entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, idx) {
                  final entry = waterLog.entries[waterLog.entries.length - 1 - idx];
                  final timeStr =
                      '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEDE9E1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('💧', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              '+${entry.amountMl} ml',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          timeStr,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
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

