import 'package:flutter/material.dart';

import '../../core/audy_theme.dart';
import 'sorting_game_models.dart';

/// Result page showing performance summary after completing a sorting game session.
/// Displays score, accuracy, time, attempts, and round breakdown.
class SortGameResultScreen extends StatelessWidget {
  const SortGameResultScreen({
    super.key,
    required this.sessionData,
    required this.theme,
    required this.levelName,
    required this.onPlayAgain,
    required this.onDone,
  });

  final SortGameSessionData sessionData;
  final SortTheme theme;
  final String levelName;
  final VoidCallback onPlayAgain;
  final VoidCallback onDone;

  int get accuracyPercent {
    if (sessionData.totalActions == 0) return 0;
    return ((sessionData.correctActions / sessionData.totalActions) * 100)
        .round();
  }

  int get totalStarsEarned => sessionData.totalStars;
  int get maxStars => sessionData.roundResults.length * 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AudyColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AudySpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onDone,
                      borderRadius: BorderRadius.circular(
                        AudySpacing.radiusMedium,
                      ),
                      child: SizedBox(
                        width: AudySpacing.touchTargetMin,
                        height: AudySpacing.touchTargetMin,
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: AudySpacing.iconMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.celebration_rounded,
                      size: 80,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(height: AudySpacing.elementGap),
                    Text('Wonderful!', style: AudyTypography.displayLarge),
                    const SizedBox(height: 8),
                    Text(
                      '$levelName Complete',
                      style: AudyTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildStarsCard(),
                      const SizedBox(height: AudySpacing.elementGap),
                      _buildSummaryCard(),
                      const SizedBox(height: AudySpacing.elementGap),
                      _buildRoundBreakdownCard(),
                      const SizedBox(height: AudySpacing.elementGap),
                      _buildAdaptiveInsightCard(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AudySpacing.elementGap),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPlayAgain,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AudyColors.skyBlue,
                        foregroundColor: AudyColors.textOnColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AudySpacing.radiusXLarge,
                          ),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Play Again',
                        style: AudyTypography.buttonText,
                      ),
                    ),
                  ),
                  const SizedBox(width: AudySpacing.elementGap),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AudyColors.mintGreen,
                        foregroundColor: AudyColors.textOnColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AudySpacing.radiusXLarge,
                          ),
                        ),
                        elevation: 4,
                      ),
                      child: Text('Done', style: AudyTypography.buttonText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AudySpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarsCard() {
    return Container(
      padding: const EdgeInsets.all(AudySpacing.cardPadding),
      decoration: BoxDecoration(
        color: AudyColors.backgroundCard,
        borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
        boxShadow: AudyShadows.cardShadow,
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: List.generate(maxStars, (index) {
              final filled = index < totalStarsEarned;
              return Icon(
                Icons.star_rounded,
                size: 40,
                color: filled ? AudyColors.starGold : AudyColors.starSilver,
              );
            }),
          ),
          const SizedBox(height: AudySpacing.smallGap),
          Text(
            '$totalStarsEarned / $maxStars Stars',
            style: AudyTypography.headingMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final sessionDuration = sessionData.sessionEndedAt
        .difference(sessionData.sessionStartedAt)
        .inSeconds;

    return Container(
      padding: const EdgeInsets.all(AudySpacing.cardPadding),
      decoration: BoxDecoration(
        color: AudyColors.backgroundCard,
        borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
        boxShadow: AudyShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Summary', style: AudyTypography.headingSmall),
          const SizedBox(height: AudySpacing.elementGap),
          _SummaryRow(
            label: 'Accuracy',
            value: '$accuracyPercent%',
            color: accuracyPercent >= 80
                ? AudyColors.mintGreen
                : AudyColors.warning,
          ),
          const SizedBox(height: AudySpacing.smallGap),
          _SummaryRow(
            label: 'Correct',
            value: '${sessionData.correctActions}',
            color: AudyColors.mintGreen,
          ),
          const SizedBox(height: AudySpacing.smallGap),
          _SummaryRow(
            label: 'Incorrect',
            value: '${sessionData.incorrectActions}',
            color: AudyColors.error,
          ),
          const SizedBox(height: AudySpacing.smallGap),
          _SummaryRow(
            label: 'Time',
            value: '${sessionDuration}s',
            color: AudyColors.skyBlue,
          ),
          const SizedBox(height: AudySpacing.smallGap),
          _SummaryRow(
            label: 'Avg Response',
            value: '${sessionData.averageResponseTimeMs}ms',
            color: AudyColors.softLavender,
          ),
          if (sessionData.hintsUsed > 0) ...[
            const SizedBox(height: AudySpacing.smallGap),
            _SummaryRow(
              label: 'Hints Used',
              value: '${sessionData.hintsUsed}',
              color: AudyColors.warning,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoundBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(AudySpacing.cardPadding),
      decoration: BoxDecoration(
        color: AudyColors.backgroundCard,
        borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
        boxShadow: AudyShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Round Breakdown', style: AudyTypography.headingSmall),
          const SizedBox(height: AudySpacing.elementGap),
          ...sessionData.roundResults.map((round) {
            final roundAccuracy = round.correctCount + round.incorrectCount > 0
                ? ((round.correctCount /
                              (round.correctCount + round.incorrectCount)) *
                          100)
                      .round()
                : 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: AudySpacing.smallGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Round ${round.roundIndex + 1}',
                          style: AudyTypography.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AudySpacing.smallGap),
                      Text(
                        '${round.correctCount}/${round.correctCount + round.incorrectCount}',
                        style: AudyTypography.bodyMedium,
                      ),
                      const SizedBox(width: AudySpacing.smallGap),
                      Text(
                        '$roundAccuracy%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: roundAccuracy >= 80
                              ? AudyColors.mintGreen
                              : AudyColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 2,
                    children: List.generate(3, (i) {
                      return Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: i < round.starsEarned
                            ? AudyColors.starGold
                            : AudyColors.starSilver,
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdaptiveInsightCard() {
    String insight;
    IconData insightIcon;
    Color insightColor;

    if (accuracyPercent >= 90) {
      insight = 'You are ready for harder levels!';
      insightIcon = Icons.trending_up_rounded;
      insightColor = AudyColors.mintGreen;
    } else if (accuracyPercent >= 60) {
      insight = 'Good progress! Keep practicing!';
      insightIcon = Icons.thumb_up_rounded;
      insightColor = AudyColors.skyBlue;
    } else {
      insight = 'Try the easier levels to build confidence!';
      insightIcon = Icons.lightbulb_rounded;
      insightColor = AudyColors.warning;
    }

    return Container(
      padding: const EdgeInsets.all(AudySpacing.cardPadding),
      decoration: BoxDecoration(
        color: insightColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
        border: Border.all(
          color: insightColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(insightIcon, size: AudySpacing.iconMedium, color: insightColor),
          const SizedBox(width: AudySpacing.smallGap),
          Expanded(
            child: Text(
              insight,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: insightColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AudyTypography.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
