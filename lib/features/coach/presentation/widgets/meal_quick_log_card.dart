import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Khẩu phần:',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    _buildStepperBtn(
                      icon: Icons.remove,
                      onTap: logged ? null : () => _adjustWeight(-20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '${_currentWeightG}g',
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
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
                  color: AppColors.primary,
                  bgColor: const Color(0xFFF0F9FF),
                  borderColor: const Color(0xFFBAE6FD),
                  bevelColor: const Color(0xFF7DD3FC),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroBadge(
                  label: 'Protein',
                  valG: _scaledProtein,
                  color: AppColors.tertiary,
                  bgColor: const Color(0xFFFFF8ED),
                  borderColor: const Color(0xFFFFE2B3),
                  bevelColor: const Color(0xFFFDBA74),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroBadge(
                  label: 'Fat',
                  valG: _scaledFat,
                  color: AppColors.secondary,
                  bgColor: const Color(0xFFFFF1F5),
                  borderColor: const Color(0xFFFECDD3),
                  bevelColor: const Color(0xFFFDA4AF),
                ),
              ),
            ],
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

  Widget _buildStepperBtn({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      shadowColor: const Color(0x20000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2DDD5), width: 1),
          ),
          child: Icon(icon, size: 16, color: AppColors.onSurface),
        ),
      ),
    );
  }

  Widget _buildMacroBadge({
    required String label,
    required double valG,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required Color bevelColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: bevelColor,
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${valG.toStringAsFixed(1)}g',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
