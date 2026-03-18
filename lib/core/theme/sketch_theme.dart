import 'package:flutter/material.dart';

class SketchTheme {
  static const ink = Color(0xFF4A3739);
  static const sunny = Color(0xFFFFD150);
  static const focusPink = Color(0xFFF26076);
  static const progressOrange = Color(0xFFFF9760);
  static const breakGreen = Color(0xFF458B73);
  static const breakInk = Color(0xFF000B58);
  static const summaryPaper = Color(0xFFFFF8E7);

  static ThemeData light() {
    const base = TextTheme(
      headlineLarge: TextStyle(fontFamily: 'Caveat', fontSize: 42, fontWeight: FontWeight.w700, color: ink),
      headlineMedium: TextStyle(fontFamily: 'Caveat', fontSize: 34, fontWeight: FontWeight.w700, color: ink),
      titleLarge: TextStyle(fontFamily: 'Caveat', fontSize: 26, fontWeight: FontWeight.w700, color: ink),
      titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: ink),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: ink),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: ink),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: sunny,
      colorScheme: ColorScheme.fromSeed(
        seedColor: focusPink,
        primary: focusPink,
        secondary: progressOrange,
        surface: sunny,
      ),
      textTheme: base,
      iconTheme: const IconThemeData(color: ink),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontFamily: 'Caveat', fontSize: 24, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: ink, width: 2),
          textStyle: const TextStyle(fontFamily: 'Caveat', fontSize: 22, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
      ),
    );
  }
}
