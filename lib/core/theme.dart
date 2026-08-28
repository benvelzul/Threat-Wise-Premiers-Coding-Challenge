import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color statItem;
  final Color cardBackground;
  final Color featureChat;
  final Color featureDiv;
  final Color featureSimulator;
  final Color featurePassword;
  final Color featureGames;
  final Color featureSubtitle;

  const AppColors({
    required this.statItem,
    required this.cardBackground,
    required this.featureChat,
    required this.featureDiv,
    required this.featureSimulator,
    required this.featurePassword,
    required this.featureGames,
    required this.featureSubtitle,
  });

  @override
  AppColors copyWith({
    Color? statItem,
    Color? cardBackground,
    Color? featureChat,
    Color? featureDiv,
    Color? featureSimulator,
    Color? featurePassword,
    Color? featureGames,
    Color? featureSubtitle,
  }) {
    return AppColors(
      statItem: statItem ?? this.statItem,
      cardBackground: cardBackground ?? this.cardBackground,
      featureChat: featureChat ?? this.featureChat,
      featureDiv: featureDiv ?? this.featureDiv,
      featureSimulator: featureSimulator ?? this.featureSimulator,
      featurePassword: featurePassword ?? this.featurePassword,
      featureGames: featureGames ?? this.featureGames,
      featureSubtitle: featureSubtitle ?? this.featureSubtitle,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      statItem: Color.lerp(statItem, other.statItem, t) ?? statItem,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      featureChat: Color.lerp(featureChat, other.featureChat, t) ?? featureChat,
      featureDiv: Color.lerp(featureDiv, other.featureDiv, t) ?? featureDiv,
      featureSimulator: Color.lerp(featureSimulator, other.featureSimulator, t) ?? featureSimulator,
      featurePassword: Color.lerp(featurePassword, other.featurePassword, t) ?? featurePassword,
      featureGames: Color.lerp(featureGames, other.featureGames, t) ?? featureGames,
      featureSubtitle: Color.lerp(featureSubtitle, other.featureSubtitle, t) ?? featureSubtitle,
    );
  }
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF46C200), // Punchy Bold Green
          onPrimary: Colors.white,

          secondary: Color(0xFF0099FF), // High-Energy Vivid Blue
          onSecondary: Colors.white,

          tertiary: Color(0xFF8A2BE2), // Vibrant Blue Violet
          onTertiary: Colors.white,

          primaryContainer: Color(0xFFBFDBFE), // Electric Ice Blue Tint
          onPrimaryContainer: Color(0xFF1E3A8A),

          secondaryContainer: Color(0xFFBAE6FD), // Sharp Sky Blue Tint
          onSecondaryContainer: Color(0xFF0C4A6E),

          surface: Color(0xFFF1F5F9), // Very light slate gray
          onSurface: Color(0xFF020617), // Ultra-dark ink text for maximum pop

          error: Color(0xFFFF0055), // Intense Electric Red
          onError: Colors.white,
        ),
        extensions: const [
          AppColors(
            statItem: Color(0xFF020617), // Pitch dark text for stats
            cardBackground: Colors.white, // Pure white cards to frame intense colors
            featureChat: Color(0xFF1D4ED8), // Deep Royal Blue
            featureDiv: Color(0xFFCBD5E1), // Crisp high-contrast divider
            featureSimulator: Color(0xFFFF2E93), // Vivid Neon Pink/Red
            featurePassword: Color(0xFFD97706), // Bold Warm Amber
            featureGames: Color(0xFF7C3AED), // Heavy Deep Violet
            featureSubtitle: Color(0xFF475569), // Medium-dark slate subtitle
          ),
        ],
        useMaterial3: true,
      );
}