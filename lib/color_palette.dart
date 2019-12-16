import 'package:flutter/material.dart';

class MapAppColors {
  static const MaterialColor vFitPrimary = MaterialColor(
    _vFitPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      350: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
      400: Color(0xFFBDBDBD),
      500: Color(_vFitPrimaryValue),
      600: Color(0xFF717d7d),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      850: Color(0xFF273238), // only for background color in dark theme
      900: Color(0xFF212121),
    },
  );
  static const int _vFitPrimaryValue = 0xFF727c7e;

  static const MaterialAccentColor vFitAccent = MaterialAccentColor(
    _vFitAccentValue,
    <int, Color>{
      100: Color(_vFitHighlightValue),
      200: Color(_vFitAccentValue),
    },
  );
  static const int _vFitAccentValue = 0xFFa3343a;
  
  static const int _vFitHighlightValue = 0xFFe4d4d4;
  
  static const Color vFitHighlight = Color(_vFitHighlightValue);
}