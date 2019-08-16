import 'package:flutter/material.dart';

class MapAppColors {
  static const MaterialColor vFitRed = MaterialColor(
    _amberPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB3),
      200: Color(0xFFFFE082),
      300: Color(0xFFFFD54F),
      400: Color(0xFFf04d57),
      500: Color(_amberPrimaryValue),
      600: Color(0xFFFFB300),
      700: Color(0xFFFFA000),
      800: Color(0xFFFF8F00),
      900: Color(0xFF7f0006),
    },
  );
  static const int _amberPrimaryValue = 0xFFb7082e;

  static const MaterialAccentColor vFitAccent = MaterialAccentColor(
    _redAccentValue,
    <int, Color>{
      100: Color(0xFFFF8A80),
      200: Color(_redAccentValue),
      400: Color(0xFFFF1744),
      700: Color(0xFFD50000),
    },
  );
  static const int _redAccentValue = 0xFF983D3D;
}