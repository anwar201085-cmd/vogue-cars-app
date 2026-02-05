import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A0E21); // Deep Navy
  static const Color accent = Color(0xFF00BFA5);  // Teal
  static const Color surface = Color(0xFF1D1E33); // Lighter Navy
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color error = Color(0xFFCF6679);
}

class AppConfig {
  static const String appName = 'Vogue Cars';
  static const String currency = 'ج.م';
  
  // Interest rates based on down payment percentage
  static double getInterestRate(double downPaymentPercent) {
    if (downPaymentPercent >= 0.50) return 0.14;
    if (downPaymentPercent >= 0.40) return 0.15;
    if (downPaymentPercent >= 0.30) return 0.155;
    if (downPaymentPercent >= 0.20) return 0.165;
    return 0.18; // Default for less than 20%
  }
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.primary,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
