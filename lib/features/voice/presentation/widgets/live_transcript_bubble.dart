import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Bubble widget showing the live streaming speech recognition transcript.
class LiveTranscriptBubble extends StatelessWidget {
  const LiveTranscriptBubble({
    super.key,
    required this.transcript,
    this.isListening = true,
  });

  final String transcript;
  final bool isListening;

  @override
  Widget build(BuildContext context) {
    final hasText = transcript.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.clayLunch,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isListening ? Icons.mic_rounded : Icons.check_circle_rounded,
                size: 16,
                color: isListening ? AppColors.primary : AppColors.brandGreen,
              ),
              const SizedBox(width: AppValues.spacing8),
              Text(
                isListening ? 'ĐANG LẮNG NGHE...' : 'BẢN GHI GIỌNG NÓI',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isListening ? AppColors.primary : AppColors.brandGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing8),
          Text(
            hasText
                ? transcript
                : 'Hãy nói tự nhiên, ví dụ: "1 tô phở bò tái, 2 quẩy và 1 ly cà phê sữa ít đường"...',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: hasText ? FontWeight.w600 : FontWeight.w400,
              fontStyle: hasText ? FontStyle.normal : FontStyle.italic,
              color: hasText
                  ? AppColors.onSurface
                  : AppColors.onSurfaceVariant.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
