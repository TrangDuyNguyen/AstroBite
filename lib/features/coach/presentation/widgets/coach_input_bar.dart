import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/voice/presentation/widgets/astro_voice_sheet.dart';

/// Message input bar with voice dictation and 3D send action button.
class CoachInputBar extends StatelessWidget {
  const CoachInputBar({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.isSending,
    required this.isListeningVoice,
    required this.showSuggestions,
    required this.onToggleSuggestions,
    required this.onToggleVoice,
    required this.onSubmitted,
    required this.onSend,
  });

  final TextEditingController textController;
  final FocusNode focusNode;
  final bool isSending;
  final bool isListeningVoice;
  final bool showSuggestions;
  final VoidCallback onToggleSuggestions;
  final VoidCallback onToggleVoice;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0E1E2337),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                enabled: !isSending,
                decoration: InputDecoration(
                  hintText: 'Hỏi AstroCoach về thực đơn, macros...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.auto_awesome,
                      color: showSuggestions
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      size: 19,
                    ),
                    tooltip: showSuggestions ? 'Thu gọn gợi ý' : 'Mở gợi ý câu hỏi',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onToggleSuggestions();
                    },
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: textController,
                        builder: (context, value, _) {
                          if (value.text.isEmpty || isListeningVoice) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                            tooltip: 'Xóa nội dung',
                            onPressed: () => textController.clear(),
                          );
                        },
                      ),
                      GestureDetector(
                        onLongPress: () {
                          HapticFeedback.heavyImpact();
                          AstroVoiceSheet.show(context);
                        },
                        child: IconButton(
                          key: const Key('coach_voice_mic_button'),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isListeningVoice
                                ? const Icon(
                                    Icons.mic_rounded,
                                    key: ValueKey('mic_active'),
                                    color: Color(0xFFEF4444),
                                    size: 21,
                                  )
                                : const Icon(
                                    Icons.mic_none_rounded,
                                    key: ValueKey('mic_idle'),
                                    color: AppColors.primary,
                                    size: 21,
                                  ),
                          ),
                          tooltip: isListeningVoice
                              ? 'Đang nghe... Bấm để dừng'
                              : 'Nói tiếng Việt (Nhấn giữ để mở AstroVoice)',
                          onPressed: isSending ? null : onToggleVoice,
                        ),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2DDD5),
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2DDD5),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.inter(
                  color: AppColors.onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                onSubmitted: onSubmitted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isSending ? null : onSend,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF0369A1),
                      offset: Offset(0, 3),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x300284C7),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.send_rounded,
                    size: 19,
                    color: Colors.white,
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
