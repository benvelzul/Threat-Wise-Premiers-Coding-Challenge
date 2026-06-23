import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFf72585),
          onPrimary: Colors.white,
          secondary: Color(0xFF7209b7),
          onSecondary: Colors.white,
          tertiary: Color(0xFF3a0ca3),
          onTertiary: Colors.white,
          primaryContainer: Color(0xFF4361ee),
          onPrimaryContainer: Colors.white,
          secondaryContainer: Color(0xFF4cc9f0),
          onSecondaryContainer: Colors.black,
          surface: Color(0xFF0A0E17),
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      );
}

