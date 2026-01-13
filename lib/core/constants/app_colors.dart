import 'package:flutter/material.dart';

/// BlueNexus App Colors
/// Bright & Cute Ocean Theme inspired by Reference UI
class AppColors {
  AppColors._();

  // Primary Colors - Soft Sky Blue Theme
  static const Color deepOceanBlue = Color(0xFF4A9BD9);
  static const Color oceanBlue = Color(0xFF5BB5E8);
  static const Color skyBlue = Color(0xFF7DD3FC);
  static const Color lightBlue = Color(0xFFBAE6FD);
  static const Color paleBlue = Color(0xFFE0F2FE);
  static const Color softCyan = Color(0xFF67E8F9);

  // Accent Colors - Coral & Pink
  static const Color coral = Color(0xFFFF8A9B);
  static const Color softPink = Color(0xFFFFB6C1);
  static const Color peach = Color(0xFFFFD4A8);

  // Eco Green (Point Color for Leaf Points)
  static const Color ecoGreen = Color(0xFF4ADE80);
  static const Color lightGreen = Color(0xFF86EFAC);
  static const Color darkGreen = Color(0xFF22C55E);
  static const Color mintGreen = Color(0xFFA7F3D0);

  // Crew Badge Colors
  static const Color bronzeBadge = Color(0xFFCD7F32);
  static const Color silverBadge = Color(0xFFC0C0C0);
  static const Color goldBadge = Color(0xFFFFD700);

  // Rarity Colors
  static const Color commonRarity = Color(0xFFB0BEC5);
  static const Color uncommonRarity = Color(0xFF4ADE80);
  static const Color rareRarity = Color(0xFF60A5FA);
  static const Color epicRarity = Color(0xFFC084FC);
  static const Color legendaryRarity = Color(0xFFFBBF24);

  // Rarity Color Aliases
  static const Color rarityCommon = commonRarity;
  static const Color rarityUncommon = uncommonRarity;
  static const Color rarityRare = rareRarity;
  static const Color rarityLegendary = legendaryRarity;

  // Crew Tier Colors
  static const Color crewBronze = bronzeBadge;
  static const Color crewSilver = silverBadge;
  static const Color crewGold = goldBadge;

  // Neutral Colors - Softer tones
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF0F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);
  static const Color black = Color(0xFF000000);

  // Semantic Colors - Softer variants
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFF60A5FA);

  // Ocean Theme Gradients
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyBlue, oceanBlue, deepOceanBlue],
  );

  static const LinearGradient softOceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [paleBlue, lightBlue, skyBlue],
  );

  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE0F7FF), Color(0xFFB8EAFF), Color(0xFF87CEEB)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, Color(0xFFF0F9FF)],
  );

  static const LinearGradient ecoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mintGreen, lightGreen, ecoGreen],
  );

  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softPink, coral, Color(0xFFFF7085)],
  );

  // Bubble Colors for decorations
  static const Color bubble1 = Color(0x40FFFFFF);
  static const Color bubble2 = Color(0x30B8EAFF);
  static const Color bubble3 = Color(0x2087CEEB);
}
