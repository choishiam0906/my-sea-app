import 'package:flutter/material.dart';

/// BlueNexus App Colors
/// Based on PRD Design Guidelines
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color deepOceanBlue = Color(0xFF004E92);
  static const Color oceanBlue = Color(0xFF0077B6);
  static const Color skyBlue = Color(0xFF00B4D8);
  static const Color lightBlue = Color(0xFF90E0EF);

  // Eco Green (Point Color for Leaf Points)
  static const Color ecoGreen = Color(0xFF2ECC71);
  static const Color lightGreen = Color(0xFF27AE60);
  static const Color darkGreen = Color(0xFF1E8449);

  // Crew Badge Colors
  static const Color bronzeBadge = Color(0xFFCD7F32);
  static const Color silverBadge = Color(0xFFC0C0C0);
  static const Color goldBadge = Color(0xFFFFD700);

  // Rarity Colors
  static const Color commonRarity = Color(0xFF9E9E9E);
  static const Color uncommonRarity = Color(0xFF4CAF50);
  static const Color rareRarity = Color(0xFF2196F3);
  static const Color epicRarity = Color(0xFF9C27B0);
  static const Color legendaryRarity = Color(0xFFFF9800);

  // Rarity Color Aliases
  static const Color rarityCommon = commonRarity;
  static const Color rarityUncommon = uncommonRarity;
  static const Color rarityRare = rareRarity;
  static const Color rarityLegendary = legendaryRarity;

  // Crew Tier Colors
  static const Color crewBronze = bronzeBadge;
  static const Color crewSilver = silverBadge;
  static const Color crewGold = goldBadge;

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  static const Color black = Color(0xFF000000);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepOceanBlue, oceanBlue, skyBlue],
  );

  static const LinearGradient ecoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkGreen, ecoGreen, lightGreen],
  );
}
