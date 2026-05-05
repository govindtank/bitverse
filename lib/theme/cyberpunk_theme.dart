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
  static const Color goldNeon = Color(0xFFFFD700);

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
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryNeon,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
          fontFamily: 'monospace',
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceMedium,
        elevation: 8,
        shadowColor: primaryNeon.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primaryNeon.withOpacity(0.3), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 14,
          ),
          elevation: 4,
          shadowColor: primaryNeon.withOpacity(0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNeon,
          side: const BorderSide(color: primaryNeon, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryNeon,
          textStyle: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold),
        ),
      ),
      iconTheme: const IconThemeData(color: primaryNeon, size: 24),
      dividerTheme: DividerThemeData(
        color: primaryNeon.withOpacity(0.3),
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryNeon,
        linearTrackColor: surfaceDark,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceMedium,
        selectedColor: primaryNeon,
        labelStyle: const TextStyle(color: textPrimary, fontSize: 12),
        side: BorderSide(color: primaryNeon.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceDark,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: const TextStyle(
          color: primaryNeon,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 4),
        displayMedium: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 3),
        displaySmall: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 2),
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, letterSpacing: 1),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 1),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textSecondary, fontSize: 10),
      ),
    );
  }

  static BoxDecoration get neonBorderDecoration {
    return BoxDecoration(
      border: Border.all(color: primaryNeon, width: 1.5),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.4),
          blurRadius: 12,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: primaryNeon.withOpacity(0.2),
          blurRadius: 24,
          spreadRadius: 4,
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
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  static BoxDecoration get glowingCardDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          surfaceMedium,
          surfaceDark.withOpacity(0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: primaryNeon.withOpacity(0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get heroDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          surfaceDark,
          backgroundDark,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.1),
          blurRadius: 30,
          spreadRadius: 5,
        ),
      ],
    );
  }

  static BoxDecoration get bottomGlowDecoration {
    return BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.5,
        colors: [
          primaryNeon.withOpacity(0.1),
          Colors.transparent,
        ],
      ),
    );
  }
}
