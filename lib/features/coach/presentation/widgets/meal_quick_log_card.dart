import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';

/// Props for [MealQuickLogCard].
class MealQuickLogProps {
  const MealQuickLogProps({
    required this.dishName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.sodium,
    this.weightG = 100,
    this.mealType = 'lunch',
  });

  final String dishName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int? sodium;
  final int weightG;
  final String mealType;

  factory MealQuickLogProps.fromMap(Map<String, dynamic> map) {
    final rawCal = map['calories'];
    final int cal = rawCal is num ? rawCal.round() : int.tryParse('$rawCal') ?? 0;

    final rawPro = map['protein'];
    final double pro = rawPro is num ? rawPro.toDouble() : double.tryParse('$rawPro') ?? 0.0;

    final rawCarb = map['carbs'];
    final double carb = rawCarb is num ? rawCarb.toDouble() : double.tryParse('$rawCarb') ?? 0.0;

    final rawFat = map['fat'];
    final double fatVal = rawFat is num ? rawFat.toDouble() : double.tryParse('$rawFat') ?? 0.0;

    final rawWeight = map['weightG'] ?? map['weight_g'] ?? map['portion_grams'];
    final int weight = rawWeight is num ? rawWeight.round() : int.tryParse('$rawWeight') ?? 100;

    final rawSodium = map['sodium'];
    final int? sodiumVal = rawSodium is num ? rawSodium.round() : int.tryParse('$rawSodium');

    return MealQuickLogProps(
      dishName: map['dishName']?.toString() ?? map['name']?.toString() ?? 'Gợi ý món ăn',
      calories: cal,
      protein: pro,
      carbs: carb,
      fat: fatVal,
      sodium: sodiumVal,
      weightG: weight > 0 ? weight : 100,
      mealType: map['mealType']?.toString() ?? 'lunch',
    );
  }

  Map<String, dynamic> toMap() => {
        'dishName': dishName,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        if (sodium != null) 'sodium': sodium,
        'weightG': weightG,
        'mealType': mealType,
      };
}

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

    return GlassCard(
      padding: const EdgeInsets.all(AppValues.cardPadding),
      borderRadius: 16,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
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
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🍲', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.props.dishName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_scaledCalories kcal',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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
                  color: AppColors.surfaceBlur,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  widget.props.mealType.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Portion Stepper Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Khẩu phần:',
                  style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
                Row(
                  children: [
                    _buildStepperBtn(
                      icon: Icons.remove,
                      onTap: logged ? null : () => _adjustWeight(-20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${_currentWeightG}g',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    _buildStepperBtn(
                      icon: Icons.add,
                      onTap: logged ? null : () => _adjustWeight(20),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3 Immutable Invariant Macro Indicators
          Row(
            children: [
              Expanded(
                child: _buildMacroBadge(
                  label: 'Carbs',
                  valG: _scaledCarbs,
                  color: AppColors.primary, // #1A73E8
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroBadge(
                  label: 'Protein',
                  valG: _scaledProtein,
                  color: AppColors.tertiary, // #FFD700
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroBadge(
                  label: 'Fat',
                  valG: _scaledFat,
                  color: AppColors.secondary, // #FF69B4
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 1-Tap Log CTA
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: logged ? null : _handleLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: logged
                    ? AppColors.surfaceBlur
                    : AppColors.primary,
                foregroundColor: Colors.white,
                elevation: logged ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    logged ? Icons.check_circle_rounded : Icons.bolt_rounded,
                    size: 18,
                    color: logged ? AppColors.success : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    logged ? '✓ Đã ghi vào nhật ký' : '⚡ Ghi vào nhật ký ngay',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: logged ? AppColors.success : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperBtn({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceBlur,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.onSurface),
      ),
    );
  }

  Widget _buildMacroBadge({
    required String label,
    required double valG,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${valG.toStringAsFixed(1)}g',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
