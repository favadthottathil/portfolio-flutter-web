import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Near-black surfaces with a single warm accent — restrained, high-contrast,
/// and deliberately monochrome apart from the amber signal color.
class AppColors {
  AppColors._();

  static const background = Color(0xFF08090B);
  static const surfaceLow = Color(0xFF0E1014);
  static const surface = Color(0xFF14171C);
  static const surfaceHigh = Color(0xFF1C2027);

  /// The one accent. Used sparingly: headlines, active states, key metrics.
  static const primary = Color(0xFFE8B33C);
  static const primaryBright = Color(0xFFF7CE6B);
  static const primaryDeep = Color(0xFFB8862A);

  /// Cool steel used for secondary emphasis — never as a second "brand" color.
  static const steel = Color(0xFF7C8899);

  /// Metallic sweep for headline text and key surfaces. Amber-only, so it
  /// reads as lighting on one material rather than a multi-hue gradient.
  static const accentGradient = LinearGradient(
    colors: [primaryBright, primary, primaryDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Near-white sweep for long headings where full amber would be too loud.
  static const chromeGradient = LinearGradient(
    colors: [Color(0xFFF2F4F7), Color(0xFFB9C0CB), Color(0xFF8B93A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle stroke used on glass surfaces.
  static Color glassStroke(double alpha) =>
      Colors.white.withValues(alpha: alpha);
}

class AppTheme {
  AppTheme._();

  static ThemeData dark(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.steel,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        Theme.of(context).textTheme,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
    );
  }
}
