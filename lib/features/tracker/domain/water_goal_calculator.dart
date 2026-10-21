/// Pure calculation utilities for water goal and hydration status
class WaterGoalCalculator {
  const WaterGoalCalculator._();

  /// Calculates recommended daily water intake in milliliters (ml)
  /// Standard clinical baseline: 35ml per kg body weight + 350ml per 30 mins active exercise
  static int calculateRecommendedGoalMl({
    required double weightKg,
    int activeMinutes = 0,
  }) {
    if (weightKg <= 0) return 2000;

    final baseWater = weightKg * 35.0;
    final activityWater = (activeMinutes / 30.0) * 350.0;
    final total = baseWater + activityWater;

    // Round to nearest 50ml and clamp to safe boundaries (1500ml - 4500ml)
    final rounded = ((total / 50.0).round() * 50).toInt();
    return rounded.clamp(1500, 4500);
  }

  /// Categorizes hydration status from percentage
  static HydrationFeedback evaluateStatus(int currentMl, int targetMl) {
    if (targetMl <= 0) return HydrationFeedback.empty;
    final ratio = currentMl / targetMl;

    if (ratio == 0) return HydrationFeedback.empty;
    if (ratio < 0.35) return HydrationFeedback.low;
    if (ratio < 0.75) return HydrationFeedback.moderate;
    if (ratio < 1.0) return HydrationFeedback.almostDone;
    return HydrationFeedback.completed;
  }
}

enum HydrationFeedback {
  empty(message: 'Hãy bắt đầu ngày mới với một ly nước ấm!', icon: '☀️'),
  low(message: 'Cần nạp thêm nước để cơ thể luôn tràn đầy năng lượng.', icon: '💧'),
  moderate(message: 'Rất tốt! Duy trì nhịp độ uống đều đặn nhé.', icon: '🌊'),
  almostDone(message: 'Sắp về đích rồi, thêm một chút nữa thôi!', icon: '✨'),
  completed(message: 'Tuyệt vời! Bạn đã hoàn thành 100% mục tiêu hôm nay 🎯', icon: '🎉');

  const HydrationFeedback({required this.message, required this.icon});

  final String message;
  final String icon;
}
