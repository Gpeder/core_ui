import 'package:flutter/material.dart';

class CoreTheme {
  static ThemeData lightTheme({Color? primaryColor}) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor ?? const Color(0xFF18181B),
        onPrimary: Colors.white,
        secondary: const Color(0xFFF4F4F5),
        onSecondary: const Color(0xFF18181B),
        surface: Colors.white,
        onSurface: const Color(0xFF18181B),
        error: const Color(0xFFEF4444),
        onError: Colors.white,
      ),
      dividerColor: const Color(0xFFE4E4E7),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      useMaterial3: true,
    );
  }

  static ThemeData darkTheme({Color? primaryColor}) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor ?? Colors.white,
        onPrimary: const Color(0xFF18181B),
        secondary: const Color(0xFF27272A),
        onSecondary: Colors.white,
        surface: const Color(0xFF18181B),
        onSurface: Colors.white,
        error: const Color(0xFFEF4444),
        onError: Colors.white,
      ),
      dividerColor: const Color(0xFF27272A),
      scaffoldBackgroundColor: Colors.black,
      useMaterial3: true,
    );
  }
}
