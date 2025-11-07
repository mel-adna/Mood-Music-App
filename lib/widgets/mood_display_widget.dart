import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/emotion_model.dart';

/// Widget for displaying detected mood/emotion with emoji and text
class MoodDisplayWidget extends StatelessWidget {
  final EmotionResult? emotionResult;
  final bool isDetecting;
  final VoidCallback? onPlayMusic;

  const MoodDisplayWidget({
    super.key,
    this.emotionResult,
    this.isDetecting = false,
    this.onPlayMusic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (isDetecting) {
      return _buildDetectingState(theme, colors);
    }

    if (emotionResult == null) {
      return _buildEmptyState(theme, colors);
    }

    return _buildEmotionDisplay(theme, colors, emotionResult!);
  }

  Widget _buildDetectingState(ThemeData theme, ColorScheme colors) {
    return _BaseCard(
      verticalPadding: 18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitWave(color: colors.primary, size: 36),
          const SizedBox(height: 14),
          Text(
            'Detecting your mood…',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Analyzing your expression',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colors) {
    return _BaseCard(
      verticalPadding: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              size: 38,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Ready to detect your mood',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Take a quick snap to reveal your emotion',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionDisplay(
    ThemeData theme,
    ColorScheme colors,
    EmotionResult result,
  ) {
    final emotion = result.emotion;
    final confidence = result.confidence;

    return LayoutBuilder(
      builder: (context, constraints) {
        final accent = _getEmotionColor(emotion);
        final compactHeight =
            constraints.hasBoundedHeight && constraints.maxHeight < 220;
        final compactWidth = constraints.maxWidth < 280;
        final compact = compactHeight || compactWidth;

        // Extra compact mode for very small spaces
        final veryCompact =
            constraints.hasBoundedHeight && constraints.maxHeight < 200;

        final horizontalPadding = veryCompact ? 10.0 : (compact ? 14.0 : 20.0);
        final verticalPadding = veryCompact ? 6.0 : (compact ? 10.0 : 22.0);
        final circleSize = veryCompact ? 38.0 : (compact ? 48.0 : 66.0);
        final emojiSize = veryCompact ? 18.0 : (compact ? 24.0 : 32.0);
        final buttonLabel = compact ? 'Play music' : 'Play matching music';

        return _BaseCard(
          backgroundColor: accent.withValues(alpha: 0.08),
          borderColor: accent.withValues(alpha: 0.28),
          borderWidth: 1.5,
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  emotion.emoji,
                  style: TextStyle(fontSize: emojiSize),
                ),
              ),
              SizedBox(height: veryCompact ? 4 : (compact ? 8 : 14)),
              Text(
                emotion.displayName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: accent,
                  fontSize: veryCompact ? 14 : (compact ? 16 : 22),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: veryCompact ? 3 : 5),
              _buildConfidenceIndicator(confidence, theme, colors, veryCompact),
              SizedBox(height: veryCompact ? 4 : (compact ? 8 : 16)),
              Text(
                _getEmotionDescription(emotion),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: veryCompact ? 11 : (compact ? 12 : 14),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: veryCompact ? 2 : (compact ? 2 : 3),
                overflow: TextOverflow.ellipsis,
              ),
              if (onPlayMusic != null) ...[
                SizedBox(height: veryCompact ? 4 : (compact ? 8 : 18)),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onPlayMusic,
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: veryCompact ? 8 : (compact ? 10 : 12),
                      ),
                    ),
                    icon: Icon(
                      Icons.play_circle_filled,
                      size: veryCompact ? 16 : 20,
                    ),
                    label: Text(
                      buttonLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: veryCompact ? 11 : (compact ? 13 : 14),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfidenceIndicator(
    double confidence,
    ThemeData theme,
    ColorScheme colors, [
    bool veryCompact = false,
  ]) {
    final percentage = (confidence * 100).round();

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_rounded,
              size: veryCompact ? 12 : 14,
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              '$percentage% confident',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontSize: veryCompact ? 10 : 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: veryCompact ? 4 : 6),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: confidence.clamp(0.0, 1.0),
              minHeight: veryCompact ? 5 : 7,
              backgroundColor: colors.outlineVariant.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getConfidenceColor(confidence),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getEmotionColor(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return Colors.amber;
      case EmotionType.sad:
        return Colors.blue;
      case EmotionType.angry:
        return Colors.red;
      case EmotionType.surprised:
        return Colors.orange;
      case EmotionType.fearful:
        return Colors.purple;
      case EmotionType.disgusted:
        return Colors.green;
      case EmotionType.neutral:
        return Colors.grey;
    }
  }

  String _getEmotionDescription(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'You seem joyful and upbeat! 🎵';
      case EmotionType.sad:
        return 'You appear to be feeling down. 💙';
      case EmotionType.angry:
        return 'You look frustrated or upset. 💪';
      case EmotionType.surprised:
        return 'You seem amazed or shocked! ✨';
      case EmotionType.fearful:
        return 'You appear worried or anxious. 🌙';
      case EmotionType.disgusted:
        return 'You seem uncomfortable or displeased. 🍃';
      case EmotionType.neutral:
        return 'You have a calm, balanced expression. 😌';
    }
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const _BaseCard({
    required this.child,
    this.horizontalPadding = 20,
    this.verticalPadding = 24,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor ?? colors.outlineVariant.withValues(alpha: 0.5),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

/// Simple loading widget for emotion detection
class EmotionLoadingWidget extends StatelessWidget {
  const EmotionLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitPulse(color: colors.primary, size: 56),
          const SizedBox(height: 16),
          Text(
            'Analyzing your emotion…',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
