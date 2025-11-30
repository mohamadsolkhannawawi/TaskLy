import 'package:flutter/material.dart';

/// App Color Palette - TaskLy Branding with Purple Header & Vibrant Alerts
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(
    0xFFA435F0,
  ); // Udemy Purple - Primary brand color
  static const Color primaryLight = Color(
    0xFFF3E5FF,
  ); // Light purple for backgrounds
  static const Color primaryDark = Color(
    0xFF7B2CBF,
  ); // Darker purple for hover states

  // Primary Dark (Text/Buttons)
  static const Color charcoalBlack = Color(
    0xFF2D2F31,
  ); // Charcoal Black for text & buttons

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // Pure White
  static const Color softGray = Color(0xFFF7F9FA); // Soft Gray for sections
  static const Color cardBackground = Colors.white;
  static const Color surface = Color(0xFFF7F9FA);

  // Text Colors
  static const Color textPrimary = Color(
    0xFF2D2F31,
  ); // Charcoal Black for primary text
  static const Color textSecondary = Color(
    0xFF64748B,
  ); // Medium gray for secondary text
  static const Color textTertiary = Color(
    0xFF94A3B8,
  ); // Light gray for tertiary text
  static const Color textInverse = Color(
    0xFFFFFFFF,
  ); // White text for dark backgrounds

  // Category Colors - Updated to work with new palette
  static const Color workColor = Color(0xFFA435F0); // Purple (primary)
  static const Color personalColor = Color(0xFFA435F0); // Purple (primary)
  static const Color shoppingColor = Color(0xFF2D2F31); // Charcoal Black
  static const Color healthColor = Color(0xFF198754); // Green (success)
  static const Color otherColor = Color(0xFF64748B); // Gray

  // Vibrant Alert Colors (NEW)
  static const Color successMint = Color(
    0xFF93DA97,
  ); // Mint Green for Add/Update/Complete
  static const Color successGreen = Color(0xFF93DA97); // Alias for successMint
  static const Color deleteRaspberry = Color(
    0xFFCD2C58,
  ); // Vibrant Raspberry for Delete
  static const Color errorRed = Color(
    0xFFCD2C58,
  ); // Red for error states (alias for delete)
  static const Color warningOrange = Color(0xFFFFC107); // Orange for warnings

  // UI Element Colors
  static const Color borderColor = Color(0xFFE2E8F0); // Light border
  static const Color dividerColor = Color(0xFFCBD5E1); // Divider line
  static const Color shadowColor = Color(0x1A000000); // Shadow overlay
  static const Color disabledColor = Color(0xFFDDDEDF); // Disabled state

  /// Get color by category name
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return workColor;
      case 'personal':
        return personalColor;
      case 'shopping':
        return shoppingColor;
      case 'health':
        return healthColor;
      default:
        return otherColor;
    }
  }

  /// Get light version of category color
  static Color getCategoryColorLight(String category) {
    return getCategoryColor(category).withValues(alpha: 0.1);
  }
}
