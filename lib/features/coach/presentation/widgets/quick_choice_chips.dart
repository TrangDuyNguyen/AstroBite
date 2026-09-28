import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _ChipVisual {
  const _ChipVisual({
    required this.bgColor,
    required this.borderColor,
    required this.bevelColor,
    required this.textColor,
    required this.icon,
    required this.iconColor,
  });

  final Color bgColor;
  final Color borderColor;
  final Color bevelColor;
  final Color textColor;
  final IconData icon;
  final Color iconColor;
}

/// CatalogItem widget rendering interactive choice chips with smart semantic styling.
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

  _ChipVisual _resolveStyle(String label, bool isSelected, {int index = 0}) {
    final lower = label.toLowerCase();

    // 1. Secondary / Partial / Alternative / Decline Action:
    // E.g. "Chỉ ghi nhận...", "Chỉ...", "Bỏ qua", "Không...", "Từ chối", "Để sau"
    final isSecondaryOrAlternative = lower.startsWith('chỉ') ||
        lower.contains('chỉ ') ||
        lower.contains('riêng') ||
        lower.contains('không') ||
        lower.contains('bỏ qua') ||
        lower.contains('từ chối') ||
        lower.contains('để sau') ||
        lower.contains('hủy');

    if (isSecondaryOrAlternative) {
      if (isSelected) {
        return const _ChipVisual(
          bgColor: Color(0xFF64748B),
          borderColor: Color(0xFF475569),
          bevelColor: Color(0xFF334155),
          textColor: Colors.white,
          icon: Icons.check_rounded,
          iconColor: Colors.white,
        );
      }
      return const _ChipVisual(
        bgColor: Colors.white,
        borderColor: Color(0xFFCBD5E1),
        bevelColor: Color(0xFF94A3B8),
        textColor: Color(0xFF475569),
        icon: Icons.check_circle_outline_rounded,
        iconColor: Color(0xFF64748B),
      );
    }

    // 2. Primary Confirm / Save / Log Action: Duolingo Lime Green
    // (e.g. "Ghi nhận Ca cao & Ăn trưa...", "Xác nhận ghi chép", "Lưu bữa ăn")
    if (lower.contains('xác nhận') ||
        lower.contains('ghi') ||
        lower.contains('chấp nhận') ||
        lower.contains('đồng ý') ||
        lower.contains('lưu') ||
        lower.contains('confirm') ||
        lower.contains('save')) {
      if (isSelected) {
        return const _ChipVisual(
          bgColor: Color(0xFF388E00),
          borderColor: Color(0xFF2E7D32),
          bevelColor: Color(0xFF1B5E20),
          textColor: Colors.white,
          icon: Icons.check_circle_rounded,
          iconColor: Colors.white,
        );
      }
      return const _ChipVisual(
        bgColor: Color(0xFF58CC02),
        borderColor: Color(0xFF388E00),
        bevelColor: Color(0xFF388E00),
        textColor: Colors.white,
        icon: Icons.check_circle_rounded,
        iconColor: Colors.white,
      );
    }

    // 3. Meal / Food Suggestion Action: Honey Tangerine Amber
    if (lower.contains('gợi ý') ||
        lower.contains('thực đơn') ||
        lower.contains('bữa') ||
        lower.contains('món') ||
        lower.contains('ăn') ||
        lower.contains('suggest')) {
      if (isSelected) {
        return const _ChipVisual(
          bgColor: Color(0xFFFF9600),
          borderColor: Color(0xFFEA580C),
          bevelColor: Color(0xFFC2410C),
          textColor: Colors.white,
          icon: Icons.restaurant_rounded,
          iconColor: Colors.white,
        );
      }
      return const _ChipVisual(
        bgColor: Color(0xFFFFF8ED),
        borderColor: Color(0xFFFFE2B3),
        bevelColor: Color(0xFFFDBA74),
        textColor: Color(0xFFB45309),
        icon: Icons.restaurant_rounded,
        iconColor: Color(0xFFD97706),
      );
    }

    // 4. Analysis / Metrics / Health: Sky Blue
    if (lower.contains('phân tích') ||
        lower.contains('đo') ||
        lower.contains('chi tiết') ||
        lower.contains('natri') ||
        lower.contains('calo') ||
        lower.contains('macro')) {
      if (isSelected) {
        return const _ChipVisual(
          bgColor: Color(0xFF0284C7),
          borderColor: Color(0xFF0369A1),
          bevelColor: Color(0xFF075985),
          textColor: Colors.white,
          icon: Icons.bolt_rounded,
          iconColor: Colors.white,
        );
      }
      return const _ChipVisual(
        bgColor: Color(0xFFF0F9FF),
        borderColor: Color(0xFFBAE6FD),
        bevelColor: Color(0xFF7DD3FC),
        textColor: Color(0xFF0369A1),
        icon: Icons.bolt_rounded,
        iconColor: AppColors.primary,
      );
    }

    // 5. Default / General Inquiry: Pure White Ceramic
    if (isSelected) {
      return const _ChipVisual(
        bgColor: AppColors.primary,
        borderColor: Color(0xFF0284C7),
        bevelColor: Color(0xFF0369A1),
        textColor: Colors.white,
        icon: Icons.arrow_forward_rounded,
        iconColor: Colors.white,
      );
    }
    return const _ChipVisual(
      bgColor: Colors.white,
      borderColor: Color(0xFFE2DDD5),
      bevelColor: Color(0xFFD8D2C6),
      textColor: AppColors.onSurface,
      icon: Icons.arrow_forward_rounded,
      iconColor: AppColors.onSurfaceVariant,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.props.chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.props.chips.asMap().entries.map((entry) {
          final index = entry.key;
          final chip = entry.value;
          final isSelected = _selectedPayload == chip.payload;
          final visual = _resolveStyle(chip.label, isSelected, index: index);

          return Material(
            color: Colors.transparent,
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
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: visual.bgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: visual.borderColor,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: visual.bevelColor,
                      offset: Offset(0, isSelected ? 1 : 2.5),
                      blurRadius: 0,
                    ),
                    const BoxShadow(
                      color: Color(0x0C000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      visual.icon,
                      size: 14,
                      color: visual.iconColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        chip.label,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: visual.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
