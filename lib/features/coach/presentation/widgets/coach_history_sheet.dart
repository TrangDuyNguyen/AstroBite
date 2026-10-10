import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../coach_controller.dart';

/// Modal bottom sheet for viewing and switching Coach chat sessions.
class CoachHistorySheet extends ConsumerWidget {
  const CoachHistorySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const CoachHistorySheet(),
    );
  }

  static Future<void> confirmDeleteSession(
    BuildContext context,
    WidgetRef ref, [
    String? date,
  ]) async {
    final messages = ref.read(coachControllerProvider).valueOrNull ?? [];
    if (date == null && messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuộc trò chuyện hiện tại đang trống.'),
          backgroundColor: AppColors.surfaceContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xoá cuộc trò chuyện?',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          date != null
              ? 'Tất cả tin nhắn trong phiên ngày $date sẽ bị xoá vĩnh viễn và không thể khôi phục.'
              : 'Tất cả tin nhắn trong phiên này sẽ bị xoá vĩnh viễn và không thể khôi phục.',
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(coachControllerProvider.notifier).deleteSession(date);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Đã xoá cuộc trò chuyện thành công.'),
            backgroundColor: AppColors.surfaceContainer,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(chatSessionsListProvider);
    final currentSelected = ref.read(coachControllerProvider.notifier).selectedDate;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.88,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4CEBF),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Header with Icon, Title & Close Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBAE6FD), width: 1.2),
                      ),
                      child: const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lịch sử hội thoại AstroCoach',
                            style: GoogleFonts.outfit(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Xem lại hoặc chuyển phiên tư vấn dinh dưỡng',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 1,
                      shadowColor: const Color(0x15000000),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(7),
                          child: Icon(Icons.close_rounded, size: 18, color: AppColors.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE5E0D8), height: 1, thickness: 1),
                const SizedBox(height: 12),

                // Session Cards
                Expanded(
                  child: sessionsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                    error: (e, _) => Center(
                      child: Text('Lỗi tải lịch sử: $e', style: const TextStyle(color: AppColors.onSurfaceVariant)),
                    ),
                    data: (sessions) {
                      if (sessions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F9FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 34,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Chưa có cuộc trò chuyện nào trước đó.',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Các phiên tư vấn dinh dưỡng hàng ngày sẽ tự động lưu tại đây.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        controller: scrollController,
                        itemCount: sessions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final s = sessions[index];
                          final dateStr = s['date'] as String? ?? '';
                          final count = s['message_count'] as int? ?? 0;
                          final lastMsg = s['last_message'] as String? ?? '';
                          final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                          final isToday = dateStr == todayStr;
                          final isSelected = (currentSelected == null && isToday) ||
                              (currentSelected == dateStr);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                ref.read(coachControllerProvider.notifier).selectSessionDate(
                                      isToday ? null : dateStr,
                                    );
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFFE5E0D8),
                                    width: isSelected ? 1.8 : 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? const Color(0xFFBAE6FD)
                                          : const Color(0xFFD4CEBF),
                                      offset: const Offset(0, 2.5),
                                      blurRadius: 0,
                                    ),
                                    const BoxShadow(
                                      color: Color(0x061E2337),
                                      offset: Offset(0, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFE0F2FE)
                                                : const Color(0xFFFAF8F5),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            isToday ? Icons.today_rounded : Icons.calendar_today_rounded,
                                            size: 15,
                                            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  isToday ? 'Hôm nay ($dateStr)' : dateStr,
                                                  style: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 13.5,
                                                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (isSelected) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE0F2FE),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    'Đang xem',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 9.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF0284C7),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0F9FF),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                                          ),
                                          child: Text(
                                            '$count tin nhắn',
                                            style: GoogleFonts.inter(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0284C7),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Tooltip(
                                          message: 'Xoá cuộc trò chuyện',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                confirmDeleteSession(context, ref, dateStr);
                                              },
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFF1F2),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: const Color(0xFFFECDD3), width: 1),
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 16,
                                                  color: AppColors.error,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (lastMsg.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFAF8F5),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFF0EBE1), width: 1),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.chat_bubble_outline_rounded,
                                              size: 12,
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                lastMsg,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.5,
                                                  color: AppColors.onSurfaceVariant,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
