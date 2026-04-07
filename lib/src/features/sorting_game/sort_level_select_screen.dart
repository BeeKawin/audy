import 'package:flutter/material.dart';

import '../../core/audy_theme.dart';
import 'sorting_game_models.dart';
import 'sort_game_engine.dart';
import 'sort_game_screen.dart';

/// Level selection page with locked/unlocked progression.
/// Shows all available levels with visual indicators for difficulty and progress.
class SortLevelSelectScreen extends StatefulWidget {
  const SortLevelSelectScreen({super.key});

  @override
  State<SortLevelSelectScreen> createState() => _SortLevelSelectScreenState();
}

class _SortLevelSelectScreenState extends State<SortLevelSelectScreen> {
  late SortGameEngine _engine;
  int _unlockedLevelIndex = 0;

  @override
  void initState() {
    super.initState();
    _engine = SortGameEngine();
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levels = _engine.getLevels(unlockedLevelIndex: _unlockedLevelIndex);

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
                      onTap: () => Navigator.pop(context),
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
                  const Icon(
                    Icons.sort_rounded,
                    size: AudySpacing.iconLarge,
                    color: AudyColors.skyBlue,
                  ),
                  const SizedBox(width: AudySpacing.smallGap),
                  Text('Sorting Game', style: AudyTypography.displayMedium),
                ],
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Center(
                child: Text(
                  'Choose a level to play!',
                  style: AudyTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Expanded(
                child: ListView.separated(
                  itemCount: levels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AudySpacing.elementGap),
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    return _LevelCard(
                      level: level,
                      onTap: level.isLocked ? null : () => _startLevel(level),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startLevel(SortGameLevel level) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SortGameScreen(level: level)),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        final starsEarned = result['stars'] as int? ?? 0;
        if (starsEarned >= level.starsRequired) {
          setState(() {
            _unlockedLevelIndex = (_unlockedLevelIndex + 1).clamp(0, 5).toInt();
          });
        }
      }
    });
  }
}

/// Individual level card showing difficulty, theme, and lock status.
class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.onTap});

  final SortGameLevel level;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = level.theme;
    final isLocked = level.isLocked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AudySpacing.cardPadding),
          decoration: BoxDecoration(
            color: AudyColors.backgroundCard,
            borderRadius: BorderRadius.circular(AudySpacing.radiusLarge),
            border: Border.all(
              color: isLocked
                  ? AudyColors.borderLight
                  : theme.primaryColor.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: AudyShadows.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: AudySpacing.iconXLarge,
                height: AudySpacing.iconXLarge,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock_rounded : theme.icon,
                  size: AudySpacing.iconLarge,
                  color: isLocked ? AudyColors.textLight : theme.primaryColor,
                ),
              ),
              const SizedBox(width: AudySpacing.elementGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(level.name, style: AudyTypography.headingSmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _DifficultyBadge(difficulty: level.difficulty),
                        const SizedBox(width: AudySpacing.smallGap),
                        Text(
                          '${level.totalRounds} rounds',
                          style: AudyTypography.bodySmall.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isLocked) ...[
                const Icon(
                  Icons.lock_outline,
                  color: AudyColors.textLight,
                  size: AudySpacing.iconMedium,
                ),
              ] else ...[
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AudyColors.skyBlue,
                  size: AudySpacing.iconMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Small badge showing difficulty level.
class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final SortDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String label;

    switch (difficulty) {
      case SortDifficulty.easy:
        badgeColor = AudyColors.mintGreen;
        label = 'Easy';
        break;
      case SortDifficulty.medium:
        badgeColor = AudyColors.warning;
        label = 'Medium';
        break;
      case SortDifficulty.hard:
        badgeColor = AudyColors.error;
        label = 'Hard';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: badgeColor,
        ),
      ),
    );
  }
}
