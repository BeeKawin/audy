import 'package:flutter/material.dart';

import 'src/core/app_routes.dart';
import 'src/core/audy_theme.dart';
import 'src/features/dashboard_page.dart';
import 'src/features/feature_pages.dart';
import 'src/features/mini_puzzle_module.dart';
import 'src/features/profile_and_rewards_pages.dart';
import 'src/state/audy_controller.dart';

void main() {
  runApp(const AudyApp());
}

class AudyApp extends StatefulWidget {
  const AudyApp({super.key});

  @override
  State<AudyApp> createState() => _AudyAppState();
}

class _AudyAppState extends State<AudyApp> {
  late final AudyController controller;

  @override
  void initState() {
    super.initState();
    controller = AudyController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudyScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AUDY - Autism-Friendly Learning',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AudyColors.backgroundCream,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AudyColors.primarySoftBlue,
            primary: AudyColors.primarySoftBlue,
            secondary: AudyColors.primaryMint,
            tertiary: AudyColors.accentSunny,
            surface: AudyColors.backgroundLight,
            brightness: Brightness.light,
          ),
          // High contrast text theme for readability
          textTheme: TextTheme(
            displayLarge: AudyTypography.displayLarge,
            displayMedium: AudyTypography.displayMedium,
            headlineLarge: AudyTypography.headingLarge,
            headlineMedium: AudyTypography.headingMedium,
            headlineSmall: AudyTypography.headingSmall,
            bodyLarge: AudyTypography.bodyLarge,
            bodyMedium: AudyTypography.bodyMedium,
            bodySmall: AudyTypography.bodySmall,
            labelLarge: AudyTypography.labelLarge,
            labelMedium: AudyTypography.labelMedium,
          ),
          // Large, friendly button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, AudySpacing.buttonHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: AudySpacing.cardPadding,
                vertical: AudySpacing.elementGap,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AudySpacing.radiusXLarge),
              ),
              elevation: 4,
              textStyle: AudyTypography.buttonText,
            ),
          ),
          // Card theme with rounded corners
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AudySpacing.radiusLarge),
            ),
          ),
          // App bar with friendly colors
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AudyColors.backgroundCream,
            foregroundColor: AudyColors.textDark,
            titleTextStyle: AudyTypography.headingMedium,
          ),
          // Bottom navigation for accessibility
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AudyColors.backgroundLight,
            selectedItemColor: AudyColors.primarySoftBlue,
            unselectedItemColor: AudyColors.textLight,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
            selectedLabelStyle: AudyTypography.labelMedium.copyWith(
              fontSize: 14,
            ),
            unselectedLabelStyle: AudyTypography.bodySmall.copyWith(
              fontSize: 12,
            ),
          ),
        ),
        initialRoute: AppRoutes.dashboard,
        routes: {
          AppRoutes.dashboard: (_) => const DashboardPage(),
          AppRoutes.games: (_) => const GamesHubPage(),
          AppRoutes.emotionGame: (_) => const EmotionGamePage(),
          AppRoutes.miniPuzzle: (_) => const MiniPuzzleModulePage(),
          AppRoutes.colorSorting: (_) => const ColorSortingPage(),
          AppRoutes.reactionTime: (_) => const ReactionTimePage(),
          AppRoutes.readingHub: (_) => const ReadPronouncePage(),
          AppRoutes.letters: (_) => const ReadingPracticePage(
            title: 'Letters Practice',
            subtitle:
                'Listen, repeat, and build confidence one sound at a time.',
            module: ReadingModule.letters,
            illustrationIcon: Icons.apple_rounded,
          ),
          AppRoutes.words: (_) => const ReadingPracticePage(
            title: 'Words Practice',
            subtitle:
                'Simple familiar words with listening and speaking practice.',
            module: ReadingModule.words,
            illustrationIcon: Icons.pets_rounded,
          ),
          AppRoutes.sentences: (_) => const ReadingPracticePage(
            title: 'Sentences Practice',
            subtitle: 'Say short sentences clearly and at a relaxed pace.',
            module: ReadingModule.sentences,
            illustrationIcon: Icons.favorite_rounded,
          ),
          AppRoutes.social: (_) => const SocialPracticePage(),
          AppRoutes.rewards: (_) => const RewardsPage(),
          AppRoutes.profile: (_) => const ProfilePage(),
        },
      ),
    );
  }
}
