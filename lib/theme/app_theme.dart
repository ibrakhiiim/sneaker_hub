import 'package:flutter/material.dart';

/// Все цвета приложения в одном месте.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E1E2C);
  static const Color accent = Color(0xFFFF6B35);
  static const Color background = Color(0xFFF6F6F9);
  static const Color surface = Colors.white;
  static const Color star = Color(0xFFFFB800);
  static const Color textSecondary = Color(0xFF8A8A9E);
  static const Color success = Color(0xFF2EAD5B);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
