import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF0AAD0A);
  static const darkGreen = Color(0xFF087D08);
  static const ink = Color(0xFF1F2933);
  static const muted = Color(0xFF667085);
  static const surface = Colors.white;
  static const softSurface = Color(0xFFF2F6F3);
  static const border = Color(0xFFE4E7EC);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: Brightness.light,
    ).copyWith(
      primary: green,
      secondary: darkGreen,
      surface: Colors.white,
      onSurface: ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ink, height: 1.05),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
        bodyLarge: TextStyle(fontSize: 16, color: muted),
        bodyMedium: TextStyle(fontSize: 14, color: muted),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.3,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: green,
          padding: const EdgeInsets.all(14),
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border, width: 0.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFE9F8E9),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: ink),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: softSurface,
        hintStyle: TextStyle(color: muted),
        prefixIconColor: muted,
        suffixIconColor: muted,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 0.1, color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: green, width: 1.2),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 24),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: ink)),
    );
  }
}
