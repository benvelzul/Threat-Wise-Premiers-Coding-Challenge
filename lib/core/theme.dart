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
          brightness: Brightness.dark,
          primary: Color(0xFF58CC02), 
          onPrimary: Colors.white,

          secondary: Color(0xFF1CB0F6),
          onSecondary: Colors.white,

          tertiary: Color(0xFF7209B7),
          onTertiary: Colors.white,

          primaryContainer: Color(0xFF1D4ED8),
          onPrimaryContainer: Colors.white,

          secondaryContainer: Color(0xFF4CC9F0),
          onSecondaryContainer: Colors.black,

          surface: Color(0xFF0A0E17),
          onSurface: Colors.white,

          error: Color(0xFFFF4D4D),
          onError: Colors.white,
        ),
        extensions: const [
          AppColors(
            statItem: Colors.white,
            cardBackground: Color(0xFF141B2D),
            featureChat: Color(0xFF3B82F6),
            featureDiv: Color.fromARGB(255, 5, 41, 99),
            featureSimulator: Color(0xFFEF4444),
            featurePassword: Color(0xFFF59E0B),
            featureGames: Color.fromARGB(255, 58, 39, 104),
            featureSubtitle: Color(0xFFB0B7C3),
          ),
        ],
        useMaterial3: true,
      );
}

