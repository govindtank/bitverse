import 'package:flutter/material.dart';

class CyberpunkTheme {
  static const Color primaryNeon = Color(0xFF00FFFF);
  static const Color secondaryNeon = Color(0xFFFF00FF);
  static const Color accentNeon = Color(0xFF00FF00);
  static const Color backgroundDark = Color(0xFF0A0A0F);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceMedium = Color(0xFF16213E);
  static const Color textPrimary = Color(0xFFE0E0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color warningNeon = Color(0xFFFFAA00);
  static const Color errorNeon = Color(0xFFFF3366);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryNeon,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        tertiary: accentNeon,
        surface: surfaceDark,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: primaryNeon,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: primaryNeon,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceMedium,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: primaryNeon, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryNeon,
          textStyle: const TextStyle(letterSpacing: 1),
        ),
      ),
      iconTheme: const IconThemeData(color: primaryNeon),
      dividerTheme: const DividerThemeData(color: primaryNeon, thickness: 0.5),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryNeon),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceMedium,
        selectedColor: primaryNeon,
        labelStyle: const TextStyle(color: textPrimary),
        side: const BorderSide(color: primaryNeon),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static BoxDecoration get neonBorderDecoration {
    return BoxDecoration(
      border: Border.all(color: primaryNeon, width: 1),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration get gradientBackground {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [backgroundDark, surfaceDark, backgroundDark],
      ),
    );
  }
}
