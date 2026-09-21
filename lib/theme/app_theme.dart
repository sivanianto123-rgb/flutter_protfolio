import 'package:flutter/material.dart';

/// Single dark theme + one accent color, code-editor-inspired via Manrope.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0F0C);
  static const Color surface = Color(0xFF10160F);
  static const Color surfaceElevated = Color(0xFF19211A);
  static const Color border = Color(0x24F5F3EC);
  static const Color accent = Color(0xFF4AFA82);
  static const Color textPrimary = Color(0xFFF5F3EC);
  static const Color textSecondary = Color(0xFF9AA39A);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = base.textTheme
        .apply(fontFamily: 'Manrope')
        .apply(bodyColor: AppColors.textPrimary, displayColor: AppColors.textPrimary);

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

  /// Instrument Serif display flourish, for accent words / large headline
  /// moments that should stand apart from the body's Manrope.
  static TextStyle display({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'InstrumentSerif',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
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
