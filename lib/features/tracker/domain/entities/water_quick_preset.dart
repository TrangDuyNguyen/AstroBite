/// Enhanced Enum for Water Quick Intake Presets
enum WaterQuickPreset {
  glass250(amountMl: 250, label: '250 ml', labelWithUnit: '250 ml (Ly)', icon: '🥛'),
  bottle500(amountMl: 500, label: '500 ml', labelWithUnit: '500 ml (Chai)', icon: '🧴'),
  flask750(amountMl: 750, label: '750 ml', labelWithUnit: '750 ml (Bình)', icon: '🍶'),
  custom(amountMl: 0, label: 'Tùy chỉnh', labelWithUnit: 'Tùy chỉnh', icon: '💧');

  const WaterQuickPreset({
    required this.amountMl,
    required this.label,
    required this.labelWithUnit,
    required this.icon,
  });

  final int amountMl;
  final String label;
  final String labelWithUnit;
  final String icon;

  static WaterQuickPreset fromAmount(int amount) {
    return switch (amount) {
      250 => WaterQuickPreset.glass250,
      500 => WaterQuickPreset.bottle500,
      750 => WaterQuickPreset.flask750,
      _ => WaterQuickPreset.custom,
    };
  }
}
