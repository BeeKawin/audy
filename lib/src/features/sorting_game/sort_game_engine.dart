import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'sorting_game_models.dart';
import 'sort_levels.dart';

/// ABA-based feedback messages for correct and incorrect actions.
/// Positive reinforcement for correct actions, gentle guidance for incorrect.
class ABAGameFeedback {
  static const positiveReinforcement = [
    'Great job! 🌟',
    'Well done!',
    'You did it!',
    'Amazing!',
    'Perfect!',
    'Fantastic!',
    'You are so smart!',
    'Keep going!',
  ];

  static const gentleCorrection = [
    'Let\'s try again!',
    'Almost! Look carefully.',
    'Not quite. Try the right one!',
    'Oops! Check the matching one.',
    'Good try! Try again.',
  ];

  static const roundComplete = [
    'Round complete! 🎉',
    'You finished the round!',
    'Wonderful work!',
  ];

  static const levelComplete = [
    'Level complete! You are a star! ⭐',
    'Amazing work! All done!',
    'You did it! Great job!',
  ];

  /// Get a random positive reinforcement message.
  static String getPositiveMessage() {
    return positiveReinforcement[Random().nextInt(
      positiveReinforcement.length,
    )];
  }

  /// Get a random gentle correction message.
  static String getCorrectionMessage() {
    return gentleCorrection[Random().nextInt(gentleCorrection.length)];
  }

  /// Get a random round complete message.
  static String getRoundCompleteMessage() {
    return roundComplete[Random().nextInt(roundComplete.length)];
  }

  /// Get a random level complete message.
  static String getLevelCompleteMessage() {
    return levelComplete[Random().nextInt(levelComplete.length)];
  }
}

/// Core game engine that manages state, ABA feedback, and difficulty progression.
/// Designed to be extended later with AI adaptivity.
class SortGameEngine extends ChangeNotifier {
  SortGameEngine({this.userId});

  final String? userId;

  SortGameLevel? _currentLevel;
  int _currentRoundIndex = 0;
  List<SortItem> _remainingItems = [];
  final List<SortActionRecord> _currentRoundActions = [];
  final List<SortRoundResult> _allRoundResults = [];

  DateTime? _roundStartTime;
  DateTime? _sessionStartTime;
  DateTime? _sessionEndTime;

  bool _isCorrect = false;
  bool _showingFeedback = false;
  String _feedbackMessage = '';
  String? _hintItemId;

  int _totalCorrect = 0;
  int _totalIncorrect = 0;
  int _totalStars = 0;
  int _hintsUsed = 0;

  bool _sessionComplete = false;
  bool _roundComplete = false;

  /// Adaptive difficulty tracking for future AI integration.
  /// Tracks recent performance to suggest easier/harder content.
  final List<bool> _recentPerformance = [];

  SortGameLevel? get currentLevel => _currentLevel;
  int get currentRoundIndex => _currentRoundIndex;
  List<SortItem> get remainingItems => List.unmodifiable(_remainingItems);
  List<SortCategory> get currentCategories =>
      _currentLevel?.rounds[_currentRoundIndex].categories ?? [];
  bool get isCorrect => _isCorrect;
  bool get showingFeedback => _showingFeedback;
  String get feedbackMessage => _feedbackMessage;
  String? get hintItemId => _hintItemId;
  int get totalCorrect => _totalCorrect;
  int get totalIncorrect => _totalIncorrect;
  int get totalStars => _totalStars;
  int get hintsUsed => _hintsUsed;
  bool get sessionComplete => _sessionComplete;
  bool get roundComplete => _roundComplete;
  int get totalRounds => _currentLevel?.totalRounds ?? 0;

  /// Current round number (1-indexed for display).
  int get currentRoundNumber => _currentRoundIndex + 1;

  /// Calculate stars for current round based on accuracy.
  int get currentRoundStars {
    if (_currentRoundActions.isEmpty) return 0;
    final accuracy = _totalCorrectForRound / _currentRoundActions.length;
    if (accuracy >= 0.9) return 3;
    if (accuracy >= 0.6) return 2;
    return 1;
  }

  int get _totalCorrectForRound =>
      _currentRoundActions.where((a) => a.isCorrect).length;

  /// Get all level definitions.
  List<SortGameLevel> getLevels({int unlockedLevelIndex = 0}) {
    return SortLevelDefinitions.allLevels(
      unlockedLevelIndex: unlockedLevelIndex,
    );
  }

  /// Start a new game session with the given level.
  void startSession(SortGameLevel level) {
    _currentLevel = level;
    _currentRoundIndex = 0;
    _remainingItems = List.from(level.rounds[0].items);
    _currentRoundActions.clear();
    _allRoundResults.clear();
    _totalCorrect = 0;
    _totalIncorrect = 0;
    _totalStars = 0;
    _hintsUsed = 0;
    _sessionComplete = false;
    _roundComplete = false;
    _showingFeedback = false;
    _feedbackMessage = '';
    _hintItemId = null;
    _recentPerformance.clear();
    _sessionStartTime = DateTime.now();
    _roundStartTime = DateTime.now();
    notifyListeners();
  }

  /// Handle a sort attempt (ABA feedback loop).
  /// [itemId] is the item being sorted, [selectedCategoryId] is the chosen category.
  void handleSortAttempt(String itemId, String selectedCategoryId) {
    if (_showingFeedback || _sessionComplete || _roundComplete) return;
    if (_remainingItems.isEmpty) return;

    final item = _remainingItems.where((i) => i.id == itemId).firstOrNull;
    if (item == null) return;

    final isCorrect = item.categoryId == selectedCategoryId;
    final startTime = _roundStartTime;
    final responseTime = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : 0;

    _recentPerformance.add(isCorrect);

    if (isCorrect) {
      _isCorrect = true;
      _totalCorrect++;
      _feedbackMessage = ABAGameFeedback.getPositiveMessage();
      _remainingItems.removeWhere((i) => i.id == itemId);
    } else {
      _isCorrect = false;
      _totalIncorrect++;
      _feedbackMessage = ABAGameFeedback.getCorrectionMessage();
      _hintItemId = item.id;
    }

    _showingFeedback = true;

    final action = SortActionRecord(
      itemId: itemId,
      selectedCategoryId: selectedCategoryId,
      correctCategoryId: item.categoryId,
      isCorrect: isCorrect,
      responseTimeMs: responseTime,
      roundIndex: _currentRoundIndex,
      hintUsed: _hintItemId == itemId && isCorrect,
    );
    _currentRoundActions.add(action);

    if (_hintItemId == itemId && isCorrect) _hintsUsed++;

    notifyListeners();

    if (isCorrect) {
      if (_remainingItems.isEmpty) {
        _completeRound();
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          _showingFeedback = false;
          _hintItemId = null;
          _roundStartTime = DateTime.now();
          notifyListeners();
        });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 1200), () {
        _showingFeedback = false;
        _hintItemId = null;
        _roundStartTime = DateTime.now();
        notifyListeners();
      });
    }
  }

  /// Complete the current round and prepare for the next.
  void _completeRound() {
    final roundTime = DateTime.now()
        .difference(_roundStartTime!)
        .inMilliseconds;
    final stars = currentRoundStars;
    _totalStars += stars;

    final roundResult = SortRoundResult(
      roundIndex: _currentRoundIndex,
      actions: List.from(_currentRoundActions),
      correctCount: _totalCorrectForRound,
      incorrectCount: _currentRoundActions.length - _totalCorrectForRound,
      roundTimeMs: roundTime,
      starsEarned: stars,
    );
    _allRoundResults.add(roundResult);
    _currentRoundActions.clear();
    _roundComplete = true;
    _feedbackMessage = ABAGameFeedback.getRoundCompleteMessage();
    notifyListeners();
  }

  /// Advance to the next round or complete the session.
  void advanceToNextRound() {
    _roundComplete = false;
    _currentRoundIndex++;
    _isCorrect = false;

    if (_currentRoundIndex >= totalRounds) {
      _finishSession();
      return;
    }

    final round = _currentLevel!.rounds[_currentRoundIndex];
    _remainingItems = List.from(round.items);
    _roundStartTime = DateTime.now();
    _showingFeedback = false;
    _feedbackMessage = '';
    _hintItemId = null;
    notifyListeners();
  }

  /// Finish the session and calculate final results.
  void _finishSession() {
    _sessionComplete = true;
    _sessionEndTime = DateTime.now();
    _feedbackMessage = ABAGameFeedback.getLevelCompleteMessage();
    notifyListeners();
  }

  /// Get the complete session data for analytics.
  SortGameSessionData getSessionData() {
    final totalActions = _totalCorrect + _totalIncorrect;
    final allActions = _allRoundResults.expand((r) => r.actions).toList();
    final avgResponseTime = allActions.isEmpty
        ? 0
        : allActions.map((a) => a.responseTimeMs).reduce((a, b) => a + b) ~/
              allActions.length;

    return SortGameSessionData(
      userId: userId,
      levelId: _currentLevel?.id ?? 'unknown',
      levelName: _currentLevel?.name ?? 'Unknown',
      difficulty: _currentLevel?.difficulty.name ?? 'unknown',
      themeName: _currentLevel?.theme.name ?? 'Unknown',
      roundResults: _allRoundResults,
      totalActions: totalActions,
      correctActions: _totalCorrect,
      incorrectActions: _totalIncorrect,
      totalStars: _totalStars,
      hintsUsed: _hintsUsed,
      completionStatus: _sessionComplete ? 'completed' : 'abandoned',
      sessionStartedAt: _sessionStartTime ?? DateTime.now(),
      sessionEndedAt: _sessionEndTime ?? DateTime.now(),
      averageResponseTimeMs: avgResponseTime,
    );
  }

  /// ABA-based adaptive difficulty suggestion.
  /// Returns a suggested difficulty adjustment based on recent performance.
  /// This is designed to be extended with full AI adaptivity later.
  AdaptiveSuggestion getSuggestion() {
    if (_recentPerformance.length < 3) return AdaptiveSuggestion.maintain;

    final recent = _recentPerformance.takeLast(5);
    final accuracy = recent.where((r) => r).length / recent.length;

    if (accuracy >= 0.9) return AdaptiveSuggestion.increase;
    if (accuracy < 0.5) return AdaptiveSuggestion.decrease;
    return AdaptiveSuggestion.maintain;
  }

  void reset() {
    _currentLevel = null;
    _currentRoundIndex = 0;
    _remainingItems.clear();
    _currentRoundActions.clear();
    _allRoundResults.clear();
    _totalCorrect = 0;
    _totalIncorrect = 0;
    _totalStars = 0;
    _hintsUsed = 0;
    _sessionComplete = false;
    _roundComplete = false;
    _showingFeedback = false;
    _feedbackMessage = '';
    _hintItemId = null;
    _recentPerformance.clear();
    _sessionStartTime = null;
    _sessionEndTime = null;
    _roundStartTime = null;
    notifyListeners();
  }
}

/// Suggestion for adaptive difficulty adjustment.
enum AdaptiveSuggestion { increase, maintain, decrease }

extension _ListExt<T> on List<T> {
  List<T> takeLast(int n) {
    if (length <= n) return this;
    return sublist(length - n);
  }
}
