import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: WaveColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: WaveColors.primary,
          secondary: WaveColors.accent,
          error: WaveColors.error,
          surface: WaveColors.surface,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: WaveColors.textPrimary,
        ),
        textTheme: _buildTextTheme(dark: true),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          foregroundColor: WaveColors.textPrimary,
          titleTextStyle: TextStyle(
            color: WaveColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardTheme(
          color: WaveColors.surfaceCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: WaveColors.surface,
          selectedItemColor: WaveColors.primary,
          unselectedItemColor: WaveColors.textMuted,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: WaveColors.surfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: WaveColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: WaveColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: WaveColors.textPrimary,
            side: const BorderSide(color: WaveColors.surfaceOverlay),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: WaveColors.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: WaveColors.primary,
          inactiveTrackColor: WaveColors.waveformInactive,
          thumbColor: WaveColors.primary,
          overlayColor: Color(0x296C63FF),
          trackHeight: 3,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? WaveColors.primary
                : WaveColors.textMuted,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? WaveColors.primaryDark
                : WaveColors.surfaceOverlay,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: WaveColors.surfaceOverlay,
          thickness: 1,
          space: 0,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  static ThemeData get light => dark.copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: WaveColors.bgLight,
        colorScheme: const ColorScheme.light(
          primary: WaveColors.primary,
          secondary: WaveColors.accent,
          error: WaveColors.error,
          surface: WaveColors.surfaceLight,
          onSurface: WaveColors.textPrimaryLight,
        ),
        textTheme: _buildTextTheme(dark: false),
      );

  static TextTheme _buildTextTheme({required bool dark}) {
    final base = GoogleFonts.interTextTheme();
    final color = dark ? WaveColors.textPrimary : WaveColors.textPrimaryLight;
    final mutedColor = dark ? WaveColors.textMuted : WaveColors.textMutedLight;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: mutedColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: color),
      bodyMedium: base.bodyMedium?.copyWith(color: mutedColor),
      bodySmall: base.bodySmall?.copyWith(color: mutedColor, fontSize: 12),
      labelLarge: base.labelLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: base.labelMedium?.copyWith(color: mutedColor),
      labelSmall: base.labelSmall?.copyWith(
        color: mutedColor,
        letterSpacing: 0.8,
      ),
    );
  }
}

// Spacing system
class WaveSpacing {
  WaveSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const double pagePadding = 20;
  static const double cardRadius = 16;
  static const double chipRadius = 50;
  static const double buttonRadius = 14;
  static const double inputRadius = 14;
}
