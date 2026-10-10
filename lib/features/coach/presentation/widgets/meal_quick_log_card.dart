import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'quick_log_components/meal_quick_log_macro_badges.dart';
import 'quick_log_components/meal_quick_log_portion_stepper.dart';
import 'quick_log_components/meal_quick_log_props.dart';

export 'quick_log_components/meal_quick_log_props.dart';

/// CatalogItem widget rendering an interactive meal suggestion with 1-Tap Log.
class MealQuickLogCard extends StatefulWidget {
  const MealQuickLogCard({
    super.key,
    required this.props,
    this.isLogged = false,
    this.onLogMeal,
  });

  final MealQuickLogProps props;
  final bool isLogged;
  final void Function(MealQuickLogProps scaledProps)? onLogMeal;

  @override
  State<MealQuickLogCard> createState() => _MealQuickLogCardState();
}

class _MealQuickLogCardState extends State<MealQuickLogCard> {
  late int _currentWeightG;
  bool _isOptimisticallyLogged = false;

  @override
  void initState() {
    super.initState();
    _currentWeightG = widget.props.weightG;
  }

  double get _scale =>
      widget.props.weightG > 0 ? _currentWeightG / widget.props.weightG : 1.0;

  int get _scaledCalories => (widget.props.calories * _scale).round();
  double get _scaledProtein => widget.props.protein * _scale;
  double get _scaledCarbs => widget.props.carbs * _scale;
  double get _scaledFat => widget.props.fat * _scale;

  void _adjustWeight(int delta) {
    final next = _currentWeightG + delta;
    if (next < 20 || next > 2000) return;
    HapticFeedback.selectionClick();
    setState(() {
      _currentWeightG = next;
    });
  }

  void _handleLog() {
    if (widget.isLogged || _isOptimisticallyLogged) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _isOptimisticallyLogged = true;
    });

    final finalProps = MealQuickLogProps(
      dishName: widget.props.dishName,
      calories: _scaledCalories,
      protein: _scaledProtein,
      carbs: _scaledCarbs,
      fat: _scaledFat,
      sodium: widget.props.sodium,
      weightG: _currentWeightG,
      mealType: widget.props.mealType,
    );

    widget.onLogMeal?.call(finalProps);
  }

  @override
  Widget build(BuildContext context) {
    final logged = widget.isLogged || _isOptimisticallyLogged;

    return Container(
      padding: const EdgeInsets.all(AppValues.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF7DD3FC),
            offset: Offset(0, 3),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0x100284C7),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Dish Name & Calories
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                ),
                child: const Text('🍲', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.props.dishName,
                      style: GoogleFonts.outfit(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_scaledCalories kcal',
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Meal Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.props.mealType.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Portion Stepper Bar
          MealQuickLogPortionStepper(
            currentWeightG: _currentWeightG,
            isLogged: logged,
            onAdjustWeight: _adjustWeight,
          ),

          const SizedBox(height: 12),

          // 3 Immutable Invariant Macro Indicators
          MealQuickLogMacroBadges(
            carbsG: _scaledCarbs,
            proteinG: _scaledProtein,
            fatG: _scaledFat,
          ),

          const SizedBox(height: 14),

          // 1-Tap Log CTA
          ClayButton(
            text: logged ? '✓ Đã ghi vào nhật ký' : '⚡ Ghi vào nhật ký ngay',
            variant: logged ? ClayButtonVariant.success : ClayButtonVariant.primary,
            height: 46,
            borderRadius: 20,
            onPressed: logged ? null : _handleLog,
          ),
        ],
      ),
    );
  }
}
