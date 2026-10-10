import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';

/// Collapsible dynamic quick actions, question suggestions, and medical disclaimer.
class CoachQuickActions extends StatelessWidget {
  const CoachQuickActions({
    super.key,
    required this.isKeyboardOpen,
    required this.isSending,
    required this.showSuggestions,
    required this.summary,
    required this.shuffleIndex,
    required this.onShuffle,
    required this.onToggleShow,
    required this.onSelectPrompt,
  });

  final bool isKeyboardOpen;
  final bool isSending;
  final bool showSuggestions;
  final DailySummary summary;
  final int shuffleIndex;
  final VoidCallback onShuffle;
  final ValueChanged<bool> onToggleShow;
  final ValueChanged<String> onSelectPrompt;

  static List<String> getDynamicQuickActions(DailySummary summary, int shuffleIndex) {
    final hour = DateTime.now().hour;
    final contextSuggestions = <String>[];

    // 1. Dynamic Context-Aware Insights based on user's real-time nutrition
    final remainingCal = summary.targetCalories - summary.totalCalories;
    if (remainingCal > 800) {
      contextSuggestions.add('🔥 Còn $remainingCal kcal, ăn gì no lâu?');
    } else if (remainingCal > 0 && remainingCal <= 400) {
      contextSuggestions.add('🥗 Còn $remainingCal kcal, món nhẹ dưới 300 kcal?');
    } else if (remainingCal <= 0 && summary.totalCalories > 0) {
      contextSuggestions.add('⚠️ Vượt ${summary.totalCalories - summary.targetCalories} kcal, mẹo cân bằng?');
    }

    final remainingProtein = summary.targetProteinG - summary.totalProteinG;
    if (remainingProtein > 20) {
      contextSuggestions.add('🥩 Thiếu ${remainingProtein}g đạm, ăn gì bù nhanh?');
    } else if (remainingProtein <= 0 && summary.totalProteinG > 0) {
      contextSuggestions.add('💪 Đã đủ đạm, ăn gì tiếp không thừa calo?');
    }

    if (summary.totalSodiumMg >= 1500) {
      contextSuggestions.add('🧂 Lượng natri cao, cách giảm tích nước?');
    }

    if (summary.totalFiberG < 10 && summary.logs.isNotEmpty) {
      contextSuggestions.add('🥦 Gợi ý món nhiều chất xơ dễ tiêu hóa');
    }

    // 2. Time-of-Day Rich Pools
    final List<String> timePool;
    if (hour >= 5 && hour < 11) {
      timePool = const [
        '🍳 Bữa sáng giàu đạm dưới 400 kcal',
        '☕ Cà phê sáng & calo cần lưu ý',
        '🥣 Bữa sáng nhanh 5 phút eat clean',
        '⚡ Nạp năng lượng khởi động ngày mới',
        '🥑 Thực phẩm giảm mỡ bụng buổi sáng',
        '🥪 Gợi ý bánh mì ngũ cốc & trứng',
      ];
    } else if (hour >= 11 && hour < 14) {
      timePool = const [
        '🍱 Gợi ý bữa trưa eat clean văn phòng',
        '🥩 Bữa trưa giàu đạm ít tinh bột',
        '🥗 Món trưa no lâu không gây buồn ngủ',
        '🍜 Bún bò/phở chứa bao nhiêu calo?',
        '🍚 Nên ăn cơm trắng hay gạo lứt?',
        '🍗 Cách chế biến ức gà mềm ngon',
      ];
    } else if (hour >= 14 && hour < 17) {
      timePool = const [
        '🍎 Ăn xế chống đói dưới 150 kcal',
        '💧 Nhắc nhở uống nước & điện giải',
        '⚡ Ăn gì trước giờ tập gym 30 phút?',
        '🍵 Trà xanh ít calo giúp tỉnh táo',
        '🥜 Các loại hạt tốt cho giảm cân',
        '🥛 Sữa chua Hy Lạp và hoa quả',
      ];
    } else if (hour >= 17 && hour < 21) {
      timePool = const [
        '🥗 Bữa tối nhẹ bụng giàu protein',
        '🥩 Phục hồi cơ sau tập gym tối',
        '🍲 Món ăn tối ít carbs hỗ trợ giảm cân',
        '🌙 Ăn tối mấy giờ để không tích mỡ?',
        '🐟 Cá hồi & rau củ áp chảo lành mạnh',
        '🥑 Bổ sung chất béo tốt vào bữa tối',
      ];
    } else {
      timePool = const [
        '🌙 Đói đêm ăn gì không sợ béo?',
        '🍵 Thức uống ấm giúp ngủ sâu giấc',
        '💤 Mẹo dập tắt cơn thèm ăn khuya',
        '📊 Nhận xét thực đơn hôm nay của tôi',
        '🥛 Uống sữa không đường trước khi ngủ?',
        '⚡ Chuẩn bị dinh dưỡng cho ngày mai',
      ];
    }

    // 3. Nutrition Science & Fitness Lifestyle Pool
    const generalPool = [
      '🏋️ Ăn trước hay sau khi tập gym tốt hơn?',
      '🔥 Cách tính thâm hụt calo chuẩn khoa học',
      '🥑 Tỷ lệ Macro chuẩn để giảm mỡ tăng cơ',
      '💧 Uống bao nhiêu lít nước mỗi ngày theo cân nặng?',
      '🧂 Tác hại của ăn mặn đối với mỡ thừa',
      '🍳 So sánh trứng luộc và trứng chiên',
      '🏃 30 phút chạy bộ đốt bao nhiêu calo?',
      '🥩 Nguồn đạm thực vật tốt cho người ăn chay',
    ];

    final combinedPool = [...timePool, ...generalPool];
    final startIndex = (shuffleIndex * 4) % combinedPool.length;
    final selectedQuestions = <String>[];
    for (var i = 0; i < 4; i++) {
      selectedQuestions.add(combinedPool[(startIndex + i) % combinedPool.length]);
    }

    return [
      '🎲 Đổi gợi ý khác',
      ...contextSuggestions.take(2),
      ...selectedQuestions,
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isSending || isKeyboardOpen) return const SizedBox.shrink();
    final actions = getDynamicQuickActions(summary, shuffleIndex);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      child: showSuggestions
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuickActions(actions),
                _buildMedicalDisclaimer(),
              ],
            )
          : _buildSuggestionsTogglePill(actions.length - 1),
    );
  }

  Widget _buildSuggestionsTogglePill(int count) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onToggleShow(true);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2DDD5), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    offset: Offset(0, 1.5),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Gợi ý câu hỏi ($count)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalDisclaimer() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0x0C1E2337),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '⚕️ AI gợi ý tham khảo, không thay thế chuyên gia y tế',
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuickActions(List<String> actions) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: actions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final action = actions[index];
                final isShuffle = action == '🎲 Đổi gợi ý khác';

                return ActionChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(
                    action,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: isShuffle ? FontWeight.w700 : FontWeight.w600,
                      color: isShuffle ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  backgroundColor: isShuffle ? const Color(0xFFE5F6FD) : Colors.white,
                  side: BorderSide(
                    color: isShuffle ? const Color(0xFFBAE6FD) : const Color(0xFFE2DDD5),
                    width: 1.2,
                  ),
                  elevation: 1,
                  shadowColor: const Color(0x15000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (isShuffle) {
                      onShuffle();
                    } else {
                      onSelectPrompt(action);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Tooltip(
              message: 'Thu gọn gợi ý',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggleShow(false);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2DDD5), width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
