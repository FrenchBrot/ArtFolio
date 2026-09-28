// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_spacing.dart';

class AppColors {
  static const primary     = Color(0xFFA78BFA);
  static const onPrimary   = Color(0xFF1F1F29);
  static const secondary   = Color(0xFF7C3AED);
  static const onSecondary = Color(0xFFFFFFFF);
  static const surface     = Color(0xFFFFFFFF);
  static const onSurface   = Color(0xFF1F1F29);
  static const background  = Color(0xFFF8F7FC);
  static const error       = Color(0xFFDC2626);
  static const onError     = Color(0xFFFFFFFF);
}

const ColorScheme _appColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
);

const TextTheme _appTextTheme = TextTheme(
  headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface),
  bodyMedium:    TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.onSurface),
  labelSmall:    TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: _appColorScheme,
  textTheme: GoogleFonts.interTextTheme(_appTextTheme),
  cardTheme: const CardThemeData(
    margin: EdgeInsets.all(AppSpacing.xs),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.onSurface,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.background,
    selectedColor: AppColors.primary,
    labelStyle: _appTextTheme.labelSmall!,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.secondary,
    unselectedItemColor: Colors.grey,
  ),
);