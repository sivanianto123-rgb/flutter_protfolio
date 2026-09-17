import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single dark theme + one accent color, Apple-esque type feel via Inter.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF111113);
  static const Color surfaceElevated = Color(0xFF1C1C1F);
  static const Color border = Color(0xFF2A2A2D);
  static const Color accent = Color(0xFF2997FF);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF86868B);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}

/// Simple responsive breakpoints used across sections.
class Breakpoints {
  Breakpoints._();

  static const double mobile = 700;
  static const double desktop = 1000;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return 24;
    if (width < desktop) return 48;
    return 96;
  }

  static double maxContentWidth = 1200;
}
