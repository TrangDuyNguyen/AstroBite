import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../coach_controller.dart';
import 'history_components/coach_history_delete_dialog.dart';
import 'history_components/coach_history_session_card.dart';

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
  ]) => CoachHistoryDeleteDialog.show(context, ref, date);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
                            l10n.coachHistorySheetTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            l10n.coachHistorySheetSubtitle,
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
                      child: Text(
                        l10n.coachHistoryLoadError(e.toString()),
                        style: const TextStyle(color: AppColors.onSurfaceVariant),
                      ),
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
                                l10n.coachHistoryEmptyTitle,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.coachHistoryEmptySubtitle,
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

                          return CoachHistorySessionCard(
                            dateStr: dateStr,
                            messageCount: count,
                            lastMessage: lastMsg,
                            isToday: isToday,
                            isSelected: isSelected,
                            onSelect: () {
                              ref.read(coachControllerProvider.notifier).selectSessionDate(
                                    isToday ? null : dateStr,
                                  );
                              Navigator.pop(context);
                            },
                            onDelete: () => CoachHistoryDeleteDialog.show(context, ref, dateStr),
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
