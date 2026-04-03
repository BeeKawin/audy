import 'package:flutter/material.dart';

/// Autism-friendly color palette designed for:
/// - High contrast for visual clarity
/// - Calming base with engaging accent colors
/// - Reduced eye strain
/// - Clear visual differentiation
class AudyColors {
  // Primary Colors - Soft and Calming
  static const Color primarySoftBlue = Color(0xFF5B9BD5);
  static const Color primaryMint = Color(0xFF6BCB77);
  static const Color primaryLavender = Color(0xFFB4A7D6);
  static const Color primaryPeach = Color(0xFFFFB997);

  // Vibrant Accent Colors - For engagement (used sparingly)
  static const Color accentSunny = Color(0xFFFFD93D);
  static const Color accentCoral = Color(0xFFFF6B6B);
  static const Color accentTurquoise = Color(0xFF4ECDC4);
  static const Color accentLime = Color(0xFF95E1A8);

  // Background Colors - High contrast but soothing
  static const Color backgroundLight = Color(0xFFFEFEFE);
  static const Color backgroundCream = Color(0xFFFDF8F3);
  static const Color backgroundSoftBlue = Color(0xFFE8F4FC);
  static const Color backgroundSoftGreen = Color(0xFFE8F8F0);

  // Text Colors - Maximum readability
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF4A4A6A);
  static const Color textLight = Color(0xFF7A7A9A);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Game Category Colors - Distinct and recognizable
  static const Color gamesEmotion = Color(0xFFFF9F43); // Warm Orange
  static const Color gamesMiniPuzzle = Color(0xFF54A0FF); // Sky Blue
  static const Color gamesColorSort = Color(0xFF5F27CD); // Purple
  static const Color gamesReaction = Color(0xFF10AC84); // Teal

  // Reading Category Colors
  static const Color readingLetters = Color(0xFFFF6B6B); // Soft Red
  static const Color readingWords = Color(0xFF4ECDC4); // Turquoise
  static const Color readingSentences = Color(0xFF95E1D3); // Mint

  // Reward Colors
  static const Color rewardGold = Color(0xFFFFD700);
  static const Color rewardSilver = Color(0xFFC0C0C0);
  static const Color rewardBronze = Color(0xFFCD7F32);
  static const Color rewardStar = Color(0xFFFFD93D);

  // Feedback Colors
  static const Color success = Color(0xFF6BCB77);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFB997);
  static const Color info = Color(0xFF5B9BD5);

  // Gradient Presets
  static const Gradient gradientSunny = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE5B4), Color(0xFFFFD93D)],
  );

  static const Gradient gradientOcean = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
  );

  static const Gradient gradientNature = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF95E1A8), Color(0xFF6BCB77)],
  );

  static const Gradient gradientMagic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB4A7D6), Color(0xFF6C5CE7)],
  );
}

/// Typography designed for readability
class AudyTypography {
  // Base text styles with larger sizes for accessibility
  static const String fontFamily = 'Nunito';

  static TextStyle get displayLarge => const TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AudyColors.textDark,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AudyColors.textDark,
    letterSpacing: 0.3,
    height: 1.3,
  );

  static TextStyle get headingLarge => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AudyColors.textDark,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static TextStyle get headingMedium => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AudyColors.textDark,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle get headingSmall => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AudyColors.textDark,
    height: 1.4,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: AudyColors.textMedium,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AudyColors.textMedium,
    height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AudyColors.textMedium,
    height: 1.5,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AudyColors.textDark,
    letterSpacing: 0.5,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AudyColors.textDark,
    letterSpacing: 0.3,
  );

  static TextStyle get buttonText => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AudyColors.textOnDark,
    letterSpacing: 0.5,
  );
}

/// Spacing and sizing constants
class AudySpacing {
  // Touch targets - minimum 48dp for accessibility
  static const double touchTargetMin = 56.0;
  static const double buttonHeight = 64.0;
  static const double cardPadding = 24.0;
  static const double sectionGap = 32.0;
  static const double elementGap = 20.0;
  static const double smallGap = 12.0;

  // Border radius for friendly, rounded shapes
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 20.0;
  static const double radiusLarge = 28.0;
  static const double radiusXLarge = 36.0;
  static const double radiusCircular = 100.0;

  // Icon sizes
  static const double iconSmall = 28.0;
  static const double iconMedium = 36.0;
  static const double iconLarge = 48.0;
  static const double iconXLarge = 64.0;
}

/// Shadow styles for depth without overwhelming visuals
class AudyShadows {
  static const BoxShadow soft = BoxShadow(
    color: Color(0x1A5B9BD5),
    blurRadius: 20,
    offset: Offset(0, 8),
    spreadRadius: -5,
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x265B9BD5),
    blurRadius: 30,
    offset: Offset(0, 12),
    spreadRadius: -8,
  );

  static const BoxShadow lifted = BoxShadow(
    color: Color(0x335B9BD5),
    blurRadius: 40,
    offset: Offset(0, 16),
    spreadRadius: -10,
  );

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A7A63C7),
      blurRadius: 15,
      offset: Offset(0, 6),
      spreadRadius: -3,
    ),
  ];
}

/// Animation durations - slower for accessibility, can be disabled
class AudyAnimation {
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration emphasis = Duration(milliseconds: 750);
}
