import 'package:flutter/material.dart';

import '../../core/audy_theme.dart';
import 'sorting_game_models.dart';

/// A single sortable item card that can be tapped to select.
class SortItemCard extends StatefulWidget {
  const SortItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
    this.isHinted = false,
    this.isDisabled = false,
  });

  final SortItem item;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isHinted;
  final bool isDisabled;

  @override
  State<SortItemCard> createState() => _SortItemCardState();
}

class _SortItemCardState extends State<SortItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AudyAnimation.quick,
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled) _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.item.color ?? AudyColors.skyBlue;
    final borderColor = widget.isHinted
        ? AudyColors.starGold
        : widget.isSelected
        ? AudyColors.skyBlue
        : AudyColors.borderLight;
    final borderWidth = widget.isHinted ? 4.0 : 3.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.isDisabled ? null : widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: AudyAnimation.normal,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AudyColors.backgroundCard,
            borderRadius: BorderRadius.circular(AudySpacing.radiusLarge),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: widget.isHinted
                ? [
                    BoxShadow(
                      color: AudyColors.starGold.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : AudyShadows.cardShadow,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final iconSize = (availableWidth * 0.45).clamp(30.0, 70.0);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.item.icon,
                      size: iconSize * 0.55,
                      color: cardColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      widget.item.label,
                      textAlign: TextAlign.center,
                      style: AudyTypography.labelMedium.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A category drop target (basket/bin) for sorting items.
class SortCategoryTarget extends StatelessWidget {
  const SortCategoryTarget({
    super.key,
    required this.category,
    required this.onTap,
    this.itemCount = 0,
    this.isHighlighted = false,
  });

  final SortCategory category;
  final VoidCallback onTap;
  final int itemCount;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final catColor = category.color ?? AudyColors.skyBlue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AudyAnimation.normal,
        padding: const EdgeInsets.all(AudySpacing.cardPadding),
        decoration: BoxDecoration(
          color: catColor.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(AudySpacing.radiusLarge),
          border: Border.all(
            color: isHighlighted ? catColor : catColor.withValues(alpha: 0.4),
            width: isHighlighted ? 4 : 2,
          ),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: catColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : AudyShadows.cardShadow,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final iconSize = (availableWidth * 0.4).clamp(28.0, 60.0);
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    size: iconSize * 0.55,
                    color: catColor,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    category.label,
                    textAlign: TextAlign.center,
                    style: AudyTypography.labelMedium.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (itemCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AudyColors.textOnColor,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ABA feedback overlay that shows positive reinforcement or gentle correction.
class ABAGameFeedbackOverlay extends StatelessWidget {
  const ABAGameFeedbackOverlay({
    super.key,
    required this.message,
    required this.isCorrect,
  });

  final String message;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AudyAnimation.normal,
      opacity: 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AudySpacing.cardPadding,
          vertical: AudySpacing.elementGap,
        ),
        decoration: BoxDecoration(
          color: isCorrect
              ? AudyColors.mintGreen.withValues(alpha: 0.95)
              : AudyColors.warning.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
          boxShadow: AudyShadows.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
              size: AudySpacing.iconMedium,
              color: AudyColors.textOnColor,
            ),
            const SizedBox(width: AudySpacing.smallGap),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AudyColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Star reward display with animation.
class StarRewardDisplay extends StatelessWidget {
  const StarRewardDisplay({
    super.key,
    required this.starsEarned,
    required this.maxStars,
    this.starSize = 48,
  });

  final int starsEarned;
  final int maxStars;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: List.generate(maxStars, (index) {
        final filled = index < starsEarned;
        return AnimatedScale(
          scale: filled ? 1.1 : 0.9,
          duration: AudyAnimation.emphasis,
          child: Icon(
            Icons.star_rounded,
            size: starSize,
            color: filled ? AudyColors.starGold : AudyColors.starSilver,
          ),
        );
      }),
    );
  }
}

/// Progress indicator showing current round and total rounds.
class SortGameProgress extends StatelessWidget {
  const SortGameProgress({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    required this.remainingItems,
  });

  final int currentRound;
  final int totalRounds;
  final int remainingItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Round $currentRound / $totalRounds',
          style: AudyTypography.labelLarge,
        ),
        if (remainingItems > 0)
          Text(
            '$remainingItems left',
            style: AudyTypography.labelMedium.copyWith(
              color: AudyColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
