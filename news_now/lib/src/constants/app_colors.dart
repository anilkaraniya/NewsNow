import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1E88E5); // Material Blue
  static const Color primaryDarkColor = Color(0xFF1565C0); // Darker Blue
  static const Color primaryLightColor = Color(0xFF42A5F5); // Lighter Blue

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF00BCD4); // Material Cyan
  static const Color secondaryDarkColor = Color(0xFF0097A7); // Darker Cyan
  static const Color secondaryLightColor = Color(0xFF4DD0E1); // Lighter Cyan

  // Accent Color
  static const Color accentColor = Color(0xFFFF6F00); // Deep Orange

  // Neutral Colors
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121); // Near Black
  static const Color textSecondaryColor = Color(0xFF757575); // Gray

  // Status Colors
  static const Color errorColor = Color(0xFFD32F2F); // Error Red
  static const Color successColor = Color(0xFF388E3C); // Success Green
  static const Color warningColor = Color(0xFFFFA000); // Warning Amber

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryColor, // Blue
      Color(0xFF0D47A1), // Deeper Blue
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      secondaryColor, // Cyan
      secondaryDarkColor, // Darker Cyan
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentColor, // Orange
      Color(0xFFE65100), // Deeper Orange
    ],
  );

  // Button Theme
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
    padding: EdgeInsets.symmetric(vertical: 16),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
    padding: EdgeInsets.symmetric(vertical: 16),
  );

  // Text Field Theme
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F5F5),
    prefixIconColor: primaryColor,
    suffixIconColor: primaryColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    labelStyle: TextStyle(color: primaryColor),
    hintStyle: TextStyle(color: textSecondaryColor),
  );

  // App Theme Data
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: elevatedButtonStyle,
    ),
    inputDecorationTheme: inputDecorationTheme,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryColor,
      ),
    ),
  );
}
