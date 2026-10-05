import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/coach/presentation/widgets/meal_quick_log_card.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/voice_log_controller.dart';
import 'live_transcript_bubble.dart';
import 'waveform_visualizer.dart';

/// Modal bottom sheet providing the 5-state AstroVoice AI recording & GenUI logging flow.
class AstroVoiceSheet extends ConsumerStatefulWidget {
  const AstroVoiceSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AstroVoiceSheet(),
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
                            const Text('🎙️', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: AppValues.spacing8),
                            Text(
                              'AstroVoice AI',
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
                          'Nói tự nhiên bữa ăn của bạn bằng tiếng Việt',
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
                LiveTranscriptBubble(
                  transcript: state.liveTranscript,
                  isListening: true,
                ),
                const SizedBox(height: AppValues.spacing24),
                WaveformVisualizer(
                  soundLevel: state.soundLevel,
                  isListening: true,
                ),
                const SizedBox(height: AppValues.spacing24),
                ClayButton(
                  text: '■ Dừng & Phân Tích',
                  variant: ClayButtonVariant.primary,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    ref
                        .read(voiceLogControllerProvider.notifier)
                        .stopListeningAndParse();
                  },
                ),
              ] else if (state.status == VoiceStatus.parsing) ...[
                LiveTranscriptBubble(
                  transcript: state.liveTranscript,
                  isListening: false,
                ),
                const SizedBox(height: AppValues.spacing32),
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
                const SizedBox(height: AppValues.spacing32),
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
              ] else if (state.status == VoiceStatus.empty) ...[
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mic_off_rounded,
                        size: 48,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: AppValues.spacing12),
                      Text(
                        state.errorMessage ??
                            'AstroBite chưa nghe rõ món bạn vừa nói.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Hãy thử nói to hơn hoặc nói lại lần nữa nhé!',
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
                  text: '🎙️ Thử Nói Lại',
                  variant: ClayButtonVariant.primary,
                  onPressed: () {
                    ref.read(voiceLogControllerProvider.notifier).startListening();
                  },
                ),
              ] else if (state.status == VoiceStatus.error) ...[
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: AppValues.spacing12),
                      Text(
                        state.errorMessage ?? 'Không thể kết nối với AI Gemini.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.spacing20),
                ClayButton(
                  text: '🔄 Thử Lại',
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
