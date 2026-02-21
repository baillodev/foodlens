import 'package:flutter/material.dart';

class AppTheme {
  // Palette principale (cohérente avec le document de rapport)
  static const Color primaryColor = Color(0xFF008575);    // teal profond
  static const Color secondaryColor = Color(0xFF6A9C93);  // sauge douce
  static const Color accentColor = Color(0xFFFF5E0E);     // orange (usage minimal)
  static const Color backgroundColor = Color(0xFFF8F6F3); // blanc chaud
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color textColor = Color(0xFF545454);        // gris charbon

  // Macros nutritionnels
  static const Color proteinColor = Color(0xFF008575);    // teal
  static const Color carbsColor = Color(0xFFFF712C);      // orange doux
  static const Color fatColor = Color(0xFF695D46);        // brun chaud
  static const Color caloriesColor = Color(0xFF6A9C93);   // sauge

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
      ),
    );
  }
}
