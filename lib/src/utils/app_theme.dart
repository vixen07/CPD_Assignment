import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4A6572);
  static const Color secondaryColor = Color(0xFF344955);
  static const Color tertiaryColor = Color(0xFFF9AA33);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF232F34);

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16.0,
    color: textColor,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.grey,
  );

  static const IconThemeData iconTheme = IconThemeData(
    color: primaryColor,
    size: 24.0,
  );

  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      textTheme: const TextTheme(
        headlineMedium: headingStyle,
        titleLarge: subheadingStyle,
        bodyLarge: bodyStyle,
        bodySmall: captionStyle,
      ),
      iconTheme: iconTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tertiaryColor,
          foregroundColor: textColor,
        ),
      ),
    );
  }
}