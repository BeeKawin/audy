import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/audy_theme.dart';
import '../core/audy_ui.dart';
import '../core/emotion_character_widget.dart';
import '../state/audy_controller.dart';
import 'emotion_game/selfie_capture_screen.dart';

class GamesHubPage extends StatelessWidget {
  const GamesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _RouteCard(
        'Emotion Game',
        'Name the feeling',
        Icons.sentiment_satisfied_alt_rounded,
        const Color(0xFFF8C7DF),
        AppRoutes.emotionGame,
      ),
      _RouteCard(
        'MiniPuzzle',
        'Cognitive training',
        Icons.extension_rounded,
        const Color(0xFFBDD8F2),
        AppRoutes.miniPuzzle,
      ),
      _RouteCard(
        'Color Sorting',
        'Match by color',
        Icons.palette_outlined,
        const Color(0xFFFFF3A6),
        AppRoutes.colorSorting,
      ),
      _RouteCard(
        'Reaction Time',
        'Tap quickly',
        Icons.bolt_rounded,
        const Color(0xFFFFDAC7),
        AppRoutes.reactionTime,
      ),
    ];

    return AudyFeaturePage(
      title: 'Games',
      subtitle: 'Play and learn with fun activities!',
      leadingLabel: 'Back to Home',
      mascot: const AudyMascot(size: 132),
      childBuilder: (context, adaptive) {
        return AudyAdaptiveGrid(
          adaptive: adaptive,
          phoneColumns: 1,
          tabletColumns: 2,
          desktopColumns: 2,
          items: cards
              .map(
                (card) => AudyActionCard(
                  title: card.title,
                  subtitle: card.subtitle,
                  icon: card.icon,
                  color: card.color,
                  adaptive: adaptive,
                  onTap: () => Navigator.pushNamed(context, card.route),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class ReadPronouncePage extends StatelessWidget {
  const ReadPronouncePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _RouteCard(
        'Letters',
        'A B C sounds',
        Icons.text_fields_rounded,
        const Color(0xFFBDD8F2),
        AppRoutes.letters,
      ),
      _RouteCard(
        'Words',
        'Simple vocabulary',
        Icons.menu_book_rounded,
        const Color(0xFFF8C7DF),
        AppRoutes.words,
      ),
      _RouteCard(
        'Sentences',
        'Short phrases',
        Icons.chat_bubble_outline_rounded,
        const Color(0xFFC9E8C1),
        AppRoutes.sentences,
      ),
    ];

    return AudyFeaturePage(
      title: 'Read & Pronounce',
      subtitle: 'Choose your learning level.',
      leadingLabel: 'Back to Home',
      mascot: const AudyMascot(size: 126),
      childBuilder: (context, adaptive) {
        return AudyAdaptiveGrid(
          adaptive: adaptive,
          phoneColumns: 1,
          tabletColumns: 3,
          desktopColumns: 3,
          items: cards
              .map(
                (card) => AudyActionCard(
                  title: card.title,
                  subtitle: card.subtitle,
                  icon: card.icon,
                  color: card.color,
                  adaptive: adaptive,
                  onTap: () => Navigator.pushNamed(context, card.route),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class ReadingPracticePage extends StatefulWidget {
  const ReadingPracticePage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.module,
    required this.illustrationIcon,
  });

  final String title;
  final String subtitle;
  final ReadingModule module;
  final IconData illustrationIcon;

  @override
  State<ReadingPracticePage> createState() => _ReadingPracticePageState();
}

class _ReadingPracticePageState extends State<ReadingPracticePage> {
  late final TextEditingController attemptController;

  @override
  void initState() {
    super.initState();
    attemptController = TextEditingController();
  }

  @override
  void dispose() {
    attemptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AudyScope.of(context);
    final state = controller.readingStates[widget.module]!;

    return AudyResponsivePage(
      builder: (context, adaptive) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopRow(
              adaptive: adaptive,
              leadingLabel: 'Back',
              trailingText:
                  'Progress: ${state.progressCurrent} / ${state.progressTotal}',
            ),
            SizedBox(height: adaptive.space(18)),
            Center(
              child: AudyBadgeIcon(
                icon: widget.illustrationIcon,
                size: adaptive.isPhone ? 88 : 106,
                background: const Color(0xFFFFE5A8),
                foreground: const Color(0xFFF28C28),
              ),
            ),
            SizedBox(height: adaptive.space(16)),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: adaptive.space(26),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF243A5A),
                    ),
                  ),
                  SizedBox(height: adaptive.space(8)),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: adaptive.space(15),
                      color: const Color(0xFF617691),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(24)),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: AudyPanel(
                  adaptive: adaptive,
                  child: Column(
                    children: [
                      Text(
                        state.prompt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: adaptive.space(
                            state.prompt.length > 8 ? 32 : 44,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: adaptive.space(18)),
                      TextField(
                        controller: attemptController,
                        decoration: const InputDecoration(
                          labelText: 'Type what the learner said',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: adaptive.space(14)),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: adaptive.space(14),
                        runSpacing: adaptive.space(14),
                        children: [
                          AudyPillButton(
                            label: 'Listen',
                            icon: Icons.volume_up_outlined,
                            color: const Color(0xFFBDD8F2),
                            adaptive: adaptive,
                            onPressed: () => controller.prepareAudioPrompt(
                              'reading_practice',
                              state.prompt,
                            ),
                          ),
                          AudyPillButton(
                            label: 'Say It!',
                            icon: Icons.mic_none_rounded,
                            color: const Color(0xFFC9E8C1),
                            adaptive: adaptive,
                            onPressed: () {
                              controller.submitReadingAttempt(
                                widget.module,
                                attemptController.text,
                              );
                              if (controller.validatePracticeInput(
                                    attemptController.text,
                                  ) ==
                                  null) {
                                attemptController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: adaptive.space(14)),
                      Text(
                        state.feedback,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: adaptive.space(13),
                          color: const Color(0xFF60758F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmotionGamePage extends StatefulWidget {
  const EmotionGamePage({super.key});

  @override
  State<EmotionGamePage> createState() => _EmotionGamePageState();
}

class _EmotionGamePageState extends State<EmotionGamePage> {
  String? _selectedAnswer;
  bool _showingFeedback = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final controller = AudyScope.of(context);
    final question = controller.currentEmotionQuestion;
    const palette = {
      'Happy': Color(0xFFFFF2A8),
      'Sad': Color(0xFFBDD8F2),
      'Angry': Color(0xFFFFDAC7),
      'Surprised': Color(0xFFF8C7DF),
      'Scared': Color(0xFFDDD0F4),
      'Calm': Color(0xFFC9E8C1),
      'Proud': Color(0xFFE7D8FA),
    };

    if (controller.isEmotionGameComplete) {
      return _FinalScoreScreen(controller: controller);
    }

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
                  Text(
                    'Round ${controller.emotionCurrentRound} / ${controller.emotionTotalRounds}',
                    style: AudyTypography.labelLarge,
                  ),
                  const SizedBox(width: AudySpacing.elementGap),
                  Text(
                    'Score: ${controller.emotionScore}',
                    style: AudyTypography.labelLarge.copyWith(
                      color: AudyColors.mintGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Center(
                child: Text(
                  'What is this emotion?',
                  style: AudyTypography.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Center(
                child: EmotionCharacterWidget(
                  emotion: question.correctAnswer,
                  size: 180,
                ),
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: AudySpacing.elementGap,
                      crossAxisSpacing: AudySpacing.elementGap,
                      childAspectRatio: 2.2,
                      children: question.options.map((option) {
                        final isSelected = _selectedAnswer == option;
                        final isAnswered = _showingFeedback;
                        final correctOption = option == question.correctAnswer;

                        Color cardColor =
                            palette[option] ?? const Color(0xFFE7D8FA);
                        if (isAnswered) {
                          if (correctOption) {
                            cardColor = AudyColors.mintGreen;
                          } else if (isSelected && !_isCorrect) {
                            cardColor = AudyColors.error.withValues(alpha: 0.3);
                          }
                        }

                        return InkWell(
                          onTap: isAnswered
                              ? null
                              : () => _handleAnswer(option, controller),
                          borderRadius: BorderRadius.circular(
                            AudySpacing.radiusLarge,
                          ),
                          child: AnimatedContainer(
                            duration: AudyAnimation.normal,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(
                                AudySpacing.radiusLarge,
                              ),
                              boxShadow: AudyShadows.cardShadow,
                              border: isSelected
                                  ? Border.all(
                                      color: AudyColors.skyBlue,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                option,
                                style: AudyTypography.headingSmall.copyWith(
                                  color: AudyColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if (_showingFeedback) ...[
                const SizedBox(height: AudySpacing.elementGap),
                Center(
                  child: Text(
                    controller.emotionFeedback,
                    textAlign: TextAlign.center,
                    style: AudyTypography.bodyLarge,
                  ),
                ),
              ],
              const SizedBox(height: AudySpacing.smallGap),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAnswer(String answer, AudyController controller) {
    if (_showingFeedback) return;

    final isCorrect = answer == controller.currentEmotionQuestion.correctAnswer;
    _selectedAnswer = answer;
    _isCorrect = isCorrect;
    _showingFeedback = true;

    if (isCorrect) {
      controller.submitEmotionAnswer(answer);

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelfieCaptureScreen(
                targetEmotion: controller.currentEmotionQuestion.correctAnswer,
              ),
            ),
          ).then((_) {
            if (mounted) {
              controller.advanceEmotionRound();
              setState(() {
                _selectedAnswer = null;
                _showingFeedback = false;
                _isCorrect = false;
              });
            }
          });
        }
      });
    } else {
      controller.emotionFeedback =
          'Nice try. The answer is ${controller.currentEmotionQuestion.correctAnswer}.';
      controller.gamesPlayed += 1;

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          controller.advanceEmotionRound();
          setState(() {
            _selectedAnswer = null;
            _showingFeedback = false;
            _isCorrect = false;
          });
        }
      });
    }
  }
}

class _FinalScoreScreen extends StatelessWidget {
  const _FinalScoreScreen({required this.controller});

  final AudyController controller;

  int get stars {
    final ratio = controller.emotionScore / controller.emotionTotalRounds;
    if (ratio >= 0.75) return 3;
    if (ratio >= 0.4) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
              const SizedBox(height: AudySpacing.sectionGap),
              const Icon(
                Icons.celebration_rounded,
                size: 80,
                color: AudyColors.mintGreen,
              ),
              const SizedBox(height: AudySpacing.elementGap),
              Text('Wonderful!', style: AudyTypography.displayLarge),
              const SizedBox(height: AudySpacing.sectionGap),
              Container(
                padding: const EdgeInsets.all(AudySpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AudyColors.backgroundCard,
                  borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
                  boxShadow: AudyShadows.cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final filled = index < stars;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.star_rounded,
                            size: 56,
                            color: filled
                                ? AudyColors.starGold
                                : AudyColors.starSilver,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AudySpacing.elementGap),
                    Text(
                      'Score: ${controller.emotionScore} / ${controller.emotionTotalRounds}',
                      style: AudyTypography.headingLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Emotion practice complete!',
                      style: AudyTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.resetEmotionGame();
                        Navigator.pop(context);
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
                      onPressed: () => Navigator.pop(context),
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
}

class ColorSortingPage extends StatelessWidget {
  const ColorSortingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AudyScope.of(context);
    final baskets = [
      _BasketData('Red', const Color(0xFFFF8D91)),
      _BasketData('Blue', const Color(0xFF8FBCEC)),
      _BasketData('Yellow', const Color(0xFFFFF68C)),
      _BasketData('Green', const Color(0xFF90F48A)),
    ];

    return AudyResponsivePage(
      builder: (context, adaptive) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopRow(
              adaptive: adaptive,
              leadingLabel: 'Back to Home',
              trailing: AudyPillButton(
                label: 'Hint',
                icon: Icons.lightbulb_outline_rounded,
                color: const Color(0xFFFFF2A8),
                adaptive: adaptive,
                onPressed: () {},
              ),
            ),
            SizedBox(height: adaptive.space(24)),
            Center(
              child: Column(
                children: [
                  Text(
                    'Color Sorting',
                    style: TextStyle(
                      fontSize: adaptive.space(28),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF243A5A),
                    ),
                  ),
                  SizedBox(height: adaptive.space(8)),
                  Text(
                    'Tap a shape, then tap the matching color basket.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: adaptive.space(15),
                      color: const Color(0xFF617691),
                    ),
                  ),
                  SizedBox(height: adaptive.space(12)),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: adaptive.space(15),
                        color: const Color(0xFF617691),
                      ),
                      children: [
                        const TextSpan(text: 'Selected: '),
                        TextSpan(
                          text:
                              controller.selectedColorPiece?.colorName ??
                              'None',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF243A5A),
                          ),
                        ),
                        TextSpan(
                          text:
                              ' (${controller.selectedColorPiece?.shape.name ?? 'none'})',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(22)),
            AudyPanel(
              adaptive: adaptive,
              child: Column(
                children: [
                  Text(
                    'Tap from here:',
                    style: TextStyle(
                      fontSize: adaptive.space(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: adaptive.space(18)),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: adaptive.space(18),
                    runSpacing: adaptive.space(18),
                    children: controller.colorPieces.map((piece) {
                      final isSelected =
                          controller.selectedColorPieceId == piece.id;
                      if (piece.shape == SortShape.triangle) {
                        return _TriangleChip(
                          color: piece.color,
                          selected: isSelected,
                          onTap: () => controller.selectColorPiece(piece.id),
                        );
                      }
                      return _ShapeChip(
                        shape: piece.shape == SortShape.circle
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        color: piece.color,
                        selected: isSelected,
                        onTap: () => controller.selectColorPiece(piece.id),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(22)),
            AudyAdaptiveGrid(
              adaptive: adaptive,
              phoneColumns: 2,
              tabletColumns: 2,
              desktopColumns: 4,
              items: baskets
                  .map(
                    (basket) => _ColorBasketCard(
                      label: basket.label,
                      color: basket.color,
                      adaptive: adaptive,
                      onTap: () => controller.submitColorBasket(basket.label),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: adaptive.space(14)),
            Center(
              child: Text(
                controller.colorFeedback,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: adaptive.space(14),
                  color: const Color(0xFF60758F),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReactionTimePage extends StatelessWidget {
  const ReactionTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AudyScope.of(context);

    return AudyResponsivePage(
      builder: (context, adaptive) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopRow(
              adaptive: adaptive,
              leadingLabel: 'Back to Home',
              trailingText: controller.reactionRoundLabel,
            ),
            SizedBox(height: adaptive.space(24)),
            Center(
              child: Column(
                children: [
                  Text(
                    'Reaction Time',
                    style: TextStyle(
                      fontSize: adaptive.space(28),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF243A5A),
                    ),
                  ),
                  SizedBox(height: adaptive.space(8)),
                  Text(
                    'Tap the symbols as quickly as you can.',
                    style: TextStyle(
                      fontSize: adaptive.space(15),
                      color: const Color(0xFF617691),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(20)),
            AudyPanel(
              adaptive: adaptive,
              padding: EdgeInsets.symmetric(
                horizontal: adaptive.space(22),
                vertical: adaptive.space(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.reactionScoreLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: adaptive.space(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      controller.reactionMissLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: adaptive.space(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(20)),
            InkWell(
              onTap: controller.registerReactionTap,
              borderRadius: BorderRadius.circular(adaptive.space(28)),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: adaptive.isPhone ? 260 : 420,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4FF),
                  borderRadius: BorderRadius.circular(adaptive.space(28)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF99A9C0).withValues(alpha: 0.15),
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    controller.reactionSymbolVisible
                        ? controller.reactionSymbol
                        : Icons.touch_app_rounded,
                    size: adaptive.isPhone ? 56 : 76,
                    color: const Color(0xFFFFB14F),
                  ),
                ),
              ),
            ),
            SizedBox(height: adaptive.space(16)),
            Center(
              child: Text(
                controller.reactionFeedback,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: adaptive.space(14),
                  color: const Color(0xFF60758F),
                ),
              ),
            ),
            SizedBox(height: adaptive.space(12)),
            Center(
              child: AudyPillButton(
                label: 'Start Round',
                color: const Color(0xFFBDD8F2),
                adaptive: adaptive,
                onPressed: controller.startReactionRound,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SocialPracticePage extends StatefulWidget {
  const SocialPracticePage({super.key});

  @override
  State<SocialPracticePage> createState() => _SocialPracticePageState();
}

class _SocialPracticePageState extends State<SocialPracticePage> {
  late final TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AudyScope.of(context);
    return AudyResponsivePage(
      builder: (context, adaptive) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AudyBackButton(
                        label: 'Back to Home',
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(height: adaptive.space(28)),
                      Text(
                        'Social Practice',
                        style: TextStyle(
                          fontSize: adaptive.space(28),
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF243A5A),
                        ),
                      ),
                      SizedBox(height: adaptive.space(8)),
                      Text(
                        'Let\'s have a friendly conversation.',
                        style: TextStyle(
                          fontSize: adaptive.space(16),
                          color: const Color(0xFF60758F),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!adaptive.isPhone) const AudyMascot(size: 110),
              ],
            ),
            SizedBox(height: adaptive.space(20)),
            AudyPanel(
              adaptive: adaptive,
              padding: EdgeInsets.symmetric(
                horizontal: adaptive.space(18),
                vertical: adaptive.space(16),
              ),
              child: Row(
                children: [
                  Text(
                    'Confidence:',
                    style: TextStyle(
                      fontSize: adaptive.space(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: adaptive.space(12)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: controller.socialConfidence,
                        minHeight: adaptive.space(12),
                        backgroundColor: const Color(0xFFE1E5EB),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF69E0A0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: adaptive.space(12)),
                  Text(
                    '${(controller.socialConfidence * 100).round()}%',
                    style: TextStyle(
                      fontSize: adaptive.space(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(20)),
            AudyPanel(
              adaptive: adaptive,
              child: SizedBox(
                height: adaptive.isPhone ? 320 : 420,
                child: ListView(
                  children: controller.socialMessages
                      .map(
                        (message) => _ChatBubble(
                          text: message.text,
                          isUser: message.isUser,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: adaptive.space(18)),
            AudyPanel(
              adaptive: adaptive,
              padding: EdgeInsets.all(adaptive.space(14)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: adaptive.isPhone ? 22 : 26,
                    backgroundColor: const Color(0xFFF8C7DF),
                    child: Icon(
                      Icons.mic_none_rounded,
                      color: const Color(0xFF243A5A),
                      size: adaptive.space(20),
                    ),
                  ),
                  SizedBox(width: adaptive.space(12)),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        filled: true,
                        fillColor: const Color(0xFFF3F6F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: adaptive.space(18),
                          vertical: adaptive.space(16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: adaptive.space(12)),
                  InkWell(
                    onTap: () {
                      controller.submitSocialMessage(messageController.text);
                      if (controller.validateChatMessage(
                            messageController.text,
                          ) ==
                          null) {
                        messageController.clear();
                      }
                    },
                    child: CircleAvatar(
                      radius: adaptive.isPhone ? 22 : 26,
                      backgroundColor: const Color(0xFFC9E8C1),
                      child: Icon(
                        Icons.send_outlined,
                        color: const Color(0xFF243A5A),
                        size: adaptive.space(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: adaptive.space(12)),
            Center(
              child: Text(
                controller.socialFeedback,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: adaptive.space(13),
                  color: const Color(0xFF60758F),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.adaptive,
    required this.leadingLabel,
    this.trailingText,
    this.trailing,
  });

  final AudyAdaptive adaptive;
  final String leadingLabel;
  final String? trailingText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AudyBackButton(
            label: leadingLabel,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        ...(trailing == null ? const <Widget>[] : <Widget>[trailing!]),
        if (trailing == null && trailingText != null)
          Text(
            trailingText!,
            style: TextStyle(
              fontSize: adaptive.space(16),
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _ShapeChip extends StatelessWidget {
  const _ShapeChip({
    required this.shape,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  final BoxShape shape;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(10)
            : null,
      ),
    );

    final selectedContent = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB1C9F5), width: 3),
      ),
      child: content,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: selected ? selectedContent : content,
    );
  }
}

class _TriangleChip extends StatelessWidget {
  const _TriangleChip({required this.color, this.selected = false, this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final triangle = SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(painter: _TrianglePainter(color)),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: selected
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFB1C9F5), width: 3),
              ),
              child: triangle,
            )
          : triangle,
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _ColorBasketCard extends StatelessWidget {
  const _ColorBasketCard({
    required this.label,
    required this.color,
    required this.adaptive,
    required this.onTap,
  });

  final String label;
  final Color color;
  final AudyAdaptive adaptive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(adaptive.space(24)),
      child: Container(
        height: adaptive.isPhone ? 150 : 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(adaptive.space(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA5B4C7).withValues(alpha: 0.20),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: adaptive.space(18),
            fontWeight: FontWeight.w800,
            color: const Color(0xFF243A5A),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFBDD8F2) : const Color(0xFFDDD0F4),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Color(0xFF243A5A)),
        ),
      ),
    );
  }
}

class _RouteCard {
  const _RouteCard(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.route,
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}

class _BasketData {
  const _BasketData(this.label, this.color);

  final String label;
  final Color color;
}
