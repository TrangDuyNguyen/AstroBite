import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/coach/presentation/widgets/meal_quick_log_card.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/voice_log_controller.dart';
import 'clay_3d_voice_mic_orb.dart';
import 'live_transcript_bubble.dart';
import 'waveform_visualizer.dart';

enum AstroVoiceMode {
  foodLogging,
  coachChat,
}

/// Modal bottom sheet providing the 5-state AstroVoice AI recording & GenUI logging flow.
class AstroVoiceSheet extends ConsumerStatefulWidget {
  const AstroVoiceSheet({
    super.key,
    this.mode = AstroVoiceMode.foodLogging,
    this.title = 'AstroVoice AI',
    this.subtitle = 'Nói tự nhiên bữa ăn của bạn bằng tiếng Việt',
    this.onTextCaptured,
  });

  final AstroVoiceMode mode;
  final String title;
  final String subtitle;
  final ValueChanged<String>? onTextCaptured;

  static Future<void> show(
    BuildContext context, {
    AstroVoiceMode mode = AstroVoiceMode.foodLogging,
    String? title,
    String? subtitle,
    ValueChanged<String>? onTextCaptured,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AstroVoiceSheet(
        mode: mode,
        title: title ?? (mode == AstroVoiceMode.coachChat ? 'AstroCoach Voice' : 'AstroVoice AI'),
        subtitle: subtitle ?? (mode == AstroVoiceMode.coachChat ? 'Nói tự nhiên câu hỏi hoặc yêu cầu của bạn...' : 'Nói tự nhiên bữa ăn của bạn bằng tiếng Việt'),
        onTextCaptured: onTextCaptured,
      ),
    );
  }

  @override
  ConsumerState<AstroVoiceSheet> createState() => _AstroVoiceSheetState();
}

class _AstroVoiceSheetState extends ConsumerState<AstroVoiceSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceLogControllerProvider.notifier).startListening();
    });
  }

  void _finishCoachDictation() {
    final text = ref.read(voiceLogControllerProvider).liveTranscript.trim();
    ref.read(voiceLogControllerProvider.notifier).cancel();
    Navigator.of(context).pop();
    if (text.isNotEmpty && widget.onTextCaptured != null) {
      widget.onTextCaptured!(text);
    }
  }

  Future<void> _handleQuickLog(MealQuickLogProps scaled) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để lưu nhật ký')),
        );
      }
      return;
    }

    final success = await ref
        .read(voiceLogControllerProvider.notifier)
        .saveMealLog(
          userId: user.uid,
          foodLogRepo: ref.read(foodLogRepositoryProvider),
          onMealRecorded: ({DateTime? date}) =>
              ref.read(streakNotifierProvider.notifier).recordMeal(date: date),
        );

    if (success && mounted) {
      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã ghi nhận ${scaled.dishName} (${scaled.calories} kcal)!'),
          backgroundColor: AppColors.brandGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceLogControllerProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ClaySheet(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/clay_3d_mic.png',
                                width: 28,
                                height: 28,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.mic_rounded,
                                  size: 26,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            Text(
                              widget.title,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppValues.spacing4),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClayIconButton(
                    icon: Icons.close_rounded,
                    onPressed: () {
                      ref.read(voiceLogControllerProvider.notifier).cancel();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing20),

              // 5 States Switcher
              if (state.status == VoiceStatus.idle ||
                  state.status == VoiceStatus.listening) ...[
                Clay3DVoiceMicOrb(
                  isListening: state.status == VoiceStatus.listening,
                  soundLevel: state.soundLevel,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (widget.mode == AstroVoiceMode.coachChat) {
                      _finishCoachDictation();
                    } else {
                      ref
                          .read(voiceLogControllerProvider.notifier)
                          .stopListeningAndParse();
                    }
                  },
                ),
                const SizedBox(height: AppValues.spacing16),
                LiveTranscriptBubble(
                  transcript: state.liveTranscript,
                  isListening: true,
                ),
                const SizedBox(height: AppValues.spacing16),
                WaveformVisualizer(
                  soundLevel: state.soundLevel,
                  isListening: true,
                ),
                const SizedBox(height: AppValues.spacing20),
                ClayButton(
                  text: widget.mode == AstroVoiceMode.coachChat
                      ? '■ Hoàn Tất & Điền Vào Chat'
                      : '■ Dừng & Phân Tích',
                  variant: ClayButtonVariant.primary,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    if (widget.mode == AstroVoiceMode.coachChat) {
                      _finishCoachDictation();
                    } else {
                      ref
                          .read(voiceLogControllerProvider.notifier)
                          .stopListeningAndParse();
                    }
                  },
                ),
              ] else if (state.status == VoiceStatus.parsing) ...[
                Clay3DVoiceMicOrb(
                  isListening: false,
                  soundLevel: 0.0,
                  isParsing: true,
                  onTap: () {},
                ),
                const SizedBox(height: AppValues.spacing16),
                LiveTranscriptBubble(
                  transcript: state.liveTranscript,
                  isListening: false,
                ),
                const SizedBox(height: AppValues.spacing24),
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: AppValues.spacing16),
                      Text(
                        'AstroBite AI đang tính toán dinh dưỡng...',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.spacing24),
              ] else if (state.status == VoiceStatus.ready &&
                  state.result != null) ...[
                LiveTranscriptBubble(
                  transcript: state.liveTranscript,
                  isListening: false,
                ),
                const SizedBox(height: AppValues.spacing16),
                MealQuickLogCard(
                  props: MealQuickLogProps(
                    dishName: state.result!.primaryDishName,
                    calories: state.result!.totalCalories,
                    protein: state.result!.proteinG,
                    carbs: state.result!.carbsG,
                    fat: state.result!.fatG,
                    sodium: state.result!.sodiumMg?.round(),
                    weightG: state.result!.totalWeightG > 0
                        ? state.result!.totalWeightG
                        : 200,
                    mealType: state.result!.mealType,
                  ),
                  onLogMeal: _handleQuickLog,
                ),
              ] else if (state.status == VoiceStatus.empty ||
                  state.status == VoiceStatus.error) ...[
                Clay3DVoiceMicOrb(
                  isListening: false,
                  soundLevel: 0.0,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(voiceLogControllerProvider.notifier).startListening();
                  },
                ),
                const SizedBox(height: AppValues.spacing16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: state.status == VoiceStatus.error
                        ? AppColors.secondary.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: state.status == VoiceStatus.error
                        ? Border.all(color: AppColors.secondary.withValues(alpha: 0.3))
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        state.errorMessage ??
                            (state.status == VoiceStatus.error
                                ? 'Không thể kết nối dịch vụ giọng nói.'
                                : 'AstroBite chưa nghe rõ món bạn vừa nói.'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: state.status == VoiceStatus.error
                              ? AppColors.secondary
                              : AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Chạm vào Mic 3D ở trên để bắt đầu nói lại nhé!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.spacing20),
                ClayButton(
                  text: state.status == VoiceStatus.error
                      ? '🔄 Thử Lại'
                      : '🎙️ Chạm Để Nói Lại',
                  variant: ClayButtonVariant.primary,
                  onPressed: () {
                    ref.read(voiceLogControllerProvider.notifier).startListening();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
