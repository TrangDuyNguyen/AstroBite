import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Props for [QuickChoiceChips].
class QuickChoiceChipsProps {
  const QuickChoiceChipsProps({
    required this.chips,
  });

  final List<QuickChipItem> chips;

  factory QuickChoiceChipsProps.fromMap(Map<String, dynamic> map) {
    final rawChips = map['chips'] ?? map['options'] ?? map['items'];
    final List<QuickChipItem> items = [];

    if (rawChips is List) {
      for (final c in rawChips) {
        if (c is Map) {
          items.add(QuickChipItem(
            label: c['label']?.toString() ?? c['text']?.toString() ?? '',
            payload: c['payload']?.toString() ?? c['action']?.toString() ?? c['label']?.toString() ?? '',
          ));
        } else if (c is String && c.isNotEmpty) {
          items.add(QuickChipItem(label: c, payload: c));
        }
      }
    }

    return QuickChoiceChipsProps(chips: items);
  }

  Map<String, dynamic> toMap() => {
        'chips': chips.map((c) => {'label': c.label, 'payload': c.payload}).toList(),
      };
}

class QuickChipItem {
  const QuickChipItem({
    required this.label,
    required this.payload,
  });

  final String label;
  final String payload;
}

/// CatalogItem widget rendering interactive choice chips that send prompts on tap.
class QuickChoiceChips extends StatefulWidget {
  const QuickChoiceChips({
    super.key,
    required this.props,
    this.onSelectChip,
  });

  final QuickChoiceChipsProps props;
  final void Function(String payload)? onSelectChip;

  @override
  State<QuickChoiceChips> createState() => _QuickChoiceChipsState();
}

class _QuickChoiceChipsState extends State<QuickChoiceChips> {
  String? _selectedPayload;

  @override
  Widget build(BuildContext context) {
    if (widget.props.chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.props.chips.map((chip) {
            final isSelected = _selectedPayload == chip.payload;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: _selectedPayload != null
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedPayload = chip.payload;
                        });
                        widget.onSelectChip?.call(chip.payload);
                      },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceBlur,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    chip.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
