import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/entities/meal_slot.dart';

enum DeleteMealAction {
  migrate,
  deleteAll,
}

class DeleteMealResult {
  const DeleteMealResult({
    required this.action,
    this.targetSlotId,
  });

  final DeleteMealAction action;
  final String? targetSlotId;
}

/// Safety Confirmation Sheet shown when deleting a meal slot that contains logged food items.
/// Prevents accidental data loss by allowing migration to another meal.
class DeleteMealConfirmationSheet extends StatefulWidget {
  const DeleteMealConfirmationSheet({
    super.key,
    required this.slotToDelete,
    required this.availableSlots,
    required this.logs,
  });

  final MealSlot slotToDelete;
  final List<MealSlot> availableSlots;
  final List<FoodLog> logs;

  static Future<DeleteMealResult?> show(
    BuildContext context, {
    required MealSlot slotToDelete,
    required List<MealSlot> availableSlots,
    required List<FoodLog> logs,
  }) {
    return showModalBottomSheet<DeleteMealResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DeleteMealConfirmationSheet(
        slotToDelete: slotToDelete,
        availableSlots: availableSlots,
        logs: logs,
      ),
    );
  }

  @override
  State<DeleteMealConfirmationSheet> createState() =>
      _DeleteMealConfirmationSheetState();
}

class _DeleteMealConfirmationSheetState
    extends State<DeleteMealConfirmationSheet> {
  late String _selectedTargetSlotId;

  @override
  void initState() {
    super.initState();
    final targets = widget.availableSlots
        .where((s) => s.id != widget.slotToDelete.id)
        .toList();
    _selectedTargetSlotId = targets.isNotEmpty ? targets.first.id : '';
  }

  int get _totalCalories =>
      widget.logs.fold(0, (sum, log) => sum + log.calories);

  @override
  Widget build(BuildContext context) {
    final candidateSlots = widget.availableSlots
        .where((s) => s.id != widget.slotToDelete.id)
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x201E2337),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: AppValues.spacing12,
        left: AppValues.screenPadding,
        right: AppValues.screenPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppValues.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.outline.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: const Text('⚠️', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xóa "${widget.slotToDelete.label}"?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Bữa này đang có ${widget.logs.length} món ăn (tổng $_totalCalories kcal)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing20),

          // Option 1: Migrate to another meal (Recommended)
          if (candidateSlots.isNotEmpty) ...[
            const Text(
              '1. Chuyển các món ăn sang bữa khác (Khuyến nghị):',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDE9E1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTargetSlotId.isNotEmpty
                      ? _selectedTargetSlotId
                      : null,
                  isExpanded: true,
                  items: candidateSlots.map((slot) {
                    return DropdownMenuItem(
                      value: slot.id,
                      child: Text(
                        'Chuyển sang: ${slot.label}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedTargetSlotId = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ClayButton(
                text: 'Chuyển Món & Xóa Bữa Này',
                onPressed: () {
                  Navigator.of(context).pop(
                    DeleteMealResult(
                      action: DeleteMealAction.migrate,
                      targetSlotId: _selectedTargetSlotId,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppValues.spacing16),
            const Divider(color: Color(0xFFEDE9E1)),
            const SizedBox(height: AppValues.spacing12),
          ],

          // Option 2: Delete everything including food logs
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(
                  const DeleteMealResult(
                    action: DeleteMealAction.deleteAll,
                  ),
                );
              },
              child: const Text(
                'Xóa Hẳn (Bao Gồm Tất Cả Món Ăn)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(
                'Hủy Bỏ',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
