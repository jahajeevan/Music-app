import 'package:flutter/material.dart';

class WaveColors {
  WaveColors._();

  // Brand
  static const primary = Color(0xFF6C63FF);       // Electric violet
  static const primaryLight = Color(0xFF9B95FF);
  static const primaryDark = Color(0xFF3D35D6);
  static const accent = Color(0xFF00D4AA);          // Mint green
  static const accentWarm = Color(0xFFFF6B6B);      // Coral red

  // Dark theme surfaces
  static const bg = Color(0xFF0A0A0F);              // Near-black
  static const surface = Color(0xFF141420);
  static const surfaceElevated = Color(0xFF1E1E2E);
  static const surfaceCard = Color(0xFF242436);
  static const surfaceOverlay = Color(0xFF2E2E45);

  // Light theme surfaces
  static const bgLight = Color(0xFFF5F5FA);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceElevatedLight = Color(0xFFF0F0F8);

  // Text — dark theme
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0C8);
  static const textMuted = Color(0xFF6B6B8A);
  static const textDisabled = Color(0xFF404055);

  // Text — light theme
  static const textPrimaryLight = Color(0xFF0A0A0F);
  static const textSecondaryLight = Color(0xFF4A4A6A);
  static const textMutedLight = Color(0xFF8A8AA0);

  // Semantic
  static const success = Color(0xFF00D4AA);
  static const warning = Color(0xFFFFB800);
  static const error = Color(0xFFFF4757);
  static const info = Color(0xFF2196F3);

  // Gradients — for album art backgrounds, hero sections
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF3D35D6)],
  );

  static const gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4AA), Color(0xFF6C63FF)],
  );

  static const gradientWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
  );

  static const gradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xFF0A0A0F)],
  );

  // Quality tier badge colors
  static const qualityHiRes = Color(0xFFFFD700);
  static const qualityLossless = Color(0xFF00D4AA);
  static const qualitySpatial = Color(0xFF6C63FF);

  // Player
  static const playerBgDark = Color(0xFF0D0D18);
  static const waveformActive = primary;
  static const waveformInactive = Color(0xFF3A3A5C);

  // Mood colors
  static const moodHappy = Color(0xFFFFD700);
  static const moodChill = Color(0xFF87CEEB);
  static const moodEnergetic = Color(0xFFFF6B6B);
  static const moodSad = Color(0xFF6495ED);
  static const moodRomantic = Color(0xFFFF69B4);
  static const moodFocus = Color(0xFF00D4AA);
  static const moodParty = Color(0xFFFF8C00);
}
