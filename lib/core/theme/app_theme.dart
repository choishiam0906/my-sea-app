import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// BlueNexus App Theme
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.deepOceanBlue,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepOceanBlue,
        secondary: AppColors.ecoGreen,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.grey900,
        onError: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
              fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.deepOceanBlue,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepOceanBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
                  fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepOceanBlue,
          side: const BorderSide(color: AppColors.deepOceanBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
                  fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deepOceanBlue,
          textStyle: const TextStyle(
                  fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.deepOceanBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(
              color: AppColors.grey500,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.deepOceanBlue,
        foregroundColor: AppColors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.deepOceanBlue,
        labelStyle: const TextStyle(
              fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
              fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        displayMedium: TextStyle(
              fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        displaySmall: TextStyle(
              fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineLarge: TextStyle(
              fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineMedium: TextStyle(
              fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineSmall: TextStyle(
              fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleLarge: TextStyle(
              fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleMedium: TextStyle(
              fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleSmall: TextStyle(
              fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        bodyLarge: TextStyle(
              fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.grey800,
        ),
        bodyMedium: TextStyle(
              fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grey800,
        ),
        bodySmall: TextStyle(
              fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        labelLarge: TextStyle(
              fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.grey900,
        ),
        labelMedium: TextStyle(
              fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.grey700,
        ),
        labelSmall: TextStyle(
              fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.grey600,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.oceanBlue,
      scaffoldBackgroundColor: AppColors.grey900,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.oceanBlue,
        secondary: AppColors.ecoGreen,
        surface: AppColors.grey800,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.white,
      ),
    );
  }
}
