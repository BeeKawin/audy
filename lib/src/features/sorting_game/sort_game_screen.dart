import 'package:flutter/material.dart';

import '../../core/audy_theme.dart';
import 'sorting_game_models.dart';
import 'sort_game_engine.dart';
import 'sort_game_widgets.dart';
import 'sort_game_result_screen.dart';

class SortGameScreen extends StatefulWidget {
  const SortGameScreen({super.key, required this.level});

  final SortGameLevel level;

  @override
  State<SortGameScreen> createState() => _SortGameScreenState();
}

class _SortGameScreenState extends State<SortGameScreen> {
  late SortGameEngine _engine;
  String? _selectedItemId;

  @override
  void initState() {
    super.initState();
    _engine = SortGameEngine();
    _engine.startSession(widget.level);
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _engine,
      builder: (context, _) {
        if (_engine.sessionComplete) {
          return _buildResultScreen();
        }

        if (_engine.roundComplete) {
          return _buildRoundCompleteOverlay();
        }

        return Scaffold(
          backgroundColor: AudyColors.backgroundPrimary,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AudySpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AudySpacing.elementGap),
                  _buildInstruction(),
                  const SizedBox(height: AudySpacing.elementGap),
                  SortGameProgress(
                    currentRound: _engine.currentRoundNumber,
                    totalRounds: _engine.totalRounds,
                    remainingItems: _engine.remainingItems.length,
                  ),
                  const SizedBox(height: AudySpacing.elementGap),
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              flex: _engine.remainingItems.length > 5 ? 3 : 2,
                              child: _buildItemsGrid(),
                            ),
                            const SizedBox(height: AudySpacing.elementGap),
                            Expanded(flex: 1, child: _buildCategoriesGrid()),
                          ],
                        ),
                        if (_engine.showingFeedback)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: ABAGameFeedbackOverlay(
                                message: _engine.feedbackMessage,
                                isCorrect: _engine.isCorrect,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            final sessionData = _engine.getSessionData();
            Navigator.pop(context, sessionData.toJson());
          },
          borderRadius: BorderRadius.circular(AudySpacing.radiusMedium),
          child: const SizedBox(
            width: AudySpacing.touchTargetMin,
            height: AudySpacing.touchTargetMin,
            child: Icon(Icons.arrow_back_rounded, size: AudySpacing.iconMedium),
          ),
        ),
        const SizedBox(width: AudySpacing.smallGap),
        Icon(
          widget.level.theme.icon,
          size: AudySpacing.iconMedium,
          color: widget.level.theme.primaryColor,
        ),
        const SizedBox(width: AudySpacing.smallGap),
        Expanded(
          child: Text(
            widget.level.name,
            style: AudyTypography.headingSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AudySpacing.smallGap),
        Flexible(
          child: StarRewardDisplay(
            starsEarned: _engine.totalStars,
            maxStars: widget.level.totalRounds * 3,
            starSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildInstruction() {
    return Center(
      child: Text(
        widget.level.theme.instructionText,
        style: AudyTypography.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildItemsGrid() {
    final items = _engine.remainingItems;
    if (items.isEmpty) {
      return const Center(
        child: Icon(
          Icons.check_circle_rounded,
          size: 80,
          color: AudyColors.mintGreen,
        ),
      );
    }

    return GridView.count(
      crossAxisCount: items.length <= 3 ? items.length : 3,
      mainAxisSpacing: AudySpacing.elementGap,
      crossAxisSpacing: AudySpacing.elementGap,
      childAspectRatio: 1.0,
      children: items.map((item) {
        final isSelected = _selectedItemId == item.id;
        final isHinted = _engine.hintItemId == item.id;

        return SortItemCard(
          item: item,
          isSelected: isSelected,
          isHinted: isHinted,
          isDisabled: _engine.showingFeedback,
          onTap: () {
            setState(() {
              _selectedItemId = item.id;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = _engine.currentCategories;

    return GridView.count(
      crossAxisCount: categories.length <= 2 ? categories.length : 3,
      mainAxisSpacing: AudySpacing.elementGap,
      crossAxisSpacing: AudySpacing.elementGap,
      childAspectRatio: 1.3,
      physics: const NeverScrollableScrollPhysics(),
      children: categories.map((category) {
        return SortCategoryTarget(
          category: category,
          itemCount: 0,
          isHighlighted: _selectedItemId != null,
          onTap: () {
            if (_selectedItemId != null && !_engine.showingFeedback) {
              _engine.handleSortAttempt(_selectedItemId!, category.id);
              setState(() {
                _selectedItemId = null;
              });
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildRoundCompleteOverlay() {
    final stars = _engine.currentRoundStars;

    return Scaffold(
      backgroundColor: AudyColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AudySpacing.screenPadding),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      final sessionData = _engine.getSessionData();
                      Navigator.pop(context, sessionData.toJson());
                    },
                    borderRadius: BorderRadius.circular(
                      AudySpacing.radiusMedium,
                    ),
                    child: const SizedBox(
                      width: AudySpacing.touchTargetMin,
                      height: AudySpacing.touchTargetMin,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: AudySpacing.iconMedium,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: AudySpacing.sectionGap),
                      const Icon(
                        Icons.celebration_rounded,
                        size: 80,
                        color: AudyColors.mintGreen,
                      ),
                      const SizedBox(height: AudySpacing.elementGap),
                      Text(
                        _engine.feedbackMessage,
                        style: AudyTypography.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AudySpacing.sectionGap),
                      StarRewardDisplay(
                        starsEarned: stars,
                        maxStars: 3,
                        starSize: 40,
                      ),
                      const SizedBox(height: AudySpacing.sectionGap),
                      Container(
                        padding: const EdgeInsets.all(AudySpacing.cardPadding),
                        decoration: BoxDecoration(
                          color: AudyColors.backgroundCard,
                          borderRadius: BorderRadius.circular(
                            AudySpacing.radiusXLarge,
                          ),
                          boxShadow: AudyShadows.cardShadow,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Round ${_engine.currentRoundNumber} Complete',
                              style: AudyTypography.headingMedium,
                            ),
                            const SizedBox(height: AudySpacing.smallGap),
                            Text(
                              'Correct: ${_engine.totalCorrect} | Try again: ${_engine.totalIncorrect}',
                              style: AudyTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AudySpacing.sectionGap),
                      ElevatedButton(
                        onPressed: () {
                          _engine.advanceToNextRound();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AudyColors.skyBlue,
                          foregroundColor: AudyColors.textOnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AudySpacing.radiusXLarge,
                            ),
                          ),
                          elevation: 4,
                          minimumSize: const Size(
                            double.infinity,
                            AudySpacing.buttonHeight,
                          ),
                        ),
                        child: Text(
                          _engine.sessionComplete
                              ? 'See Results'
                              : 'Next Round',
                          style: AudyTypography.buttonText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AudySpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final sessionData = _engine.getSessionData();

    return SortGameResultScreen(
      sessionData: sessionData,
      theme: widget.level.theme,
      levelName: widget.level.name,
      onPlayAgain: () {
        _engine.reset();
        _engine.startSession(widget.level);
        setState(() {
          _selectedItemId = null;
        });
      },
      onDone: () {
        Navigator.pop(context, {
          'stars': sessionData.totalStars,
          'data': sessionData.toJson(),
        });
      },
    );
  }
}
